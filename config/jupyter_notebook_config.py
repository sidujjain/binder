def script_post_save(model, os_path, contents_manager, **kwargs):
    try:
        import os
        import jovian
        os.chdir(os.path.dirname(os_path))
        print(os.path.dirname(os_path))
        jovian.utils.rcfile.reset_cache()
        jovian.commit(filename=os.path.basename(os_path), is_cli=True, require_write_access=True)
    except Exception:
        import traceback
        traceback.print_exc()
        pass


c.FileContentsManager.post_save_hook = script_post_save
