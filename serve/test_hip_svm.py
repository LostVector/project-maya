"""CPU-only checks for the ROCr workaround's engine launch environment."""
import os
import unittest
from unittest.mock import patch

from serve.server import child_env
from tools import maya_names


class HipSvmEnvironment(unittest.TestCase):
    def environment(self, cfg, inherited=None, platform="linux"):
        with patch.dict(os.environ, inherited or {}, clear=True), patch("sys.platform", platform):
            return child_env(maya_names.env_in(cfg))

    def test_default_leaves_runtime_unchanged(self):
        self.assertNotIn("HSA_USE_SVM", self.environment({"backend": "hip"}))

    def test_config_opt_in_reaches_fresh_child(self):
        env = self.environment({"backend": "hip", "env": {"MAYA_HIP_DISABLE_SVM": "1"}})
        self.assertEqual(env["HSA_USE_SVM"], "0")
        self.assertNotIn("HSA_USE_SVM", os.environ)

    def test_shell_opt_in(self):
        env = self.environment({"backend": "hip"}, {"MAYA_HIP_DISABLE_SVM": "1"})
        self.assertEqual(env["HSA_USE_SVM"], "0")

    def test_config_can_disable_inherited_opt_in(self):
        env = self.environment({"backend": "hip", "env": {"MAYA_HIP_DISABLE_SVM": "0"}},
                               {"MAYA_HIP_DISABLE_SVM": "1"})
        self.assertNotIn("HSA_USE_SVM", env)

    def test_disabled_and_other_backends_are_unchanged(self):
        for backend, platform, value in [("hip", "linux", "0"), ("cuda", "linux", "1"),
                                         ("hip", "win32", "1"), ("cpu", "linux", "1")]:
            with self.subTest(backend=backend, platform=platform, value=value):
                env = self.environment({"backend": backend, "env": {"MAYA_HIP_DISABLE_SVM": value}},
                                       platform=platform)
                self.assertNotIn("HSA_USE_SVM", env)

    def test_direct_runtime_override_wins(self):
        cfg = {"backend": "hip", "env": {"MAYA_HIP_DISABLE_SVM": "1", "HSA_USE_SVM": "1"}}
        self.assertEqual(self.environment(cfg)["HSA_USE_SVM"], "1")
        cfg["env"].pop("HSA_USE_SVM")
        self.assertEqual(self.environment(cfg, {"HSA_USE_SVM": "1"})["HSA_USE_SVM"], "1")


if __name__ == "__main__":
    unittest.main()
