class PathConfig {
  // oauth
  // login
  // settings
  // add
  // / => prj list
  // prj/:save_id/
  // prj/:save_id/permissions
  // prj/:save_id/settings
  // prj/:save_id/folder/:folder_id/
  // prj/:save_id/folder/:folder_id/settings
  // prj/:save_id/folder/:folder_id/:file_id    mb -page ?
  // prj/:save_id/folder/:folder_id/:file_id/settings  - not set
  // translate/:file_id
  // translate/:file_id/:translate_id    mb -page ?
  // translate/:file_id/:search results ?

  final String root;
  final String prjId;
  final String option;
  final int folderId;
  final int fileId;
  final bool detail;

  String get currentPath {
    String _path = root != null ? '/$root' : '/';
    if (prjId != null) {
      _path += '/$prjId';
      if (option != null) _path += '/$option';
    }
    return _path;
  }

  PathConfig popPathCfg() {
    if (fileId != null && detail) return PathConfig.files(prjId, folderId);
    if (folderId != null && detail) return PathConfig.folders(prjId, folderId);
    // if (['add', 'settings', 'translate', 'unknown'].contains(root)) return PathConfig.projects();
    return PathConfig.projects();
  }

  // bool isDetail = false;
  // bool isUnknown = false;
  // OAuth callback
  PathConfig.oauth()
      : root = 'oauth',
        prjId = null,
        option = null,
        folderId = null,
        fileId = null,
        detail = false;

  // Login page
  bool get isLogin => root != null && root == 'login';
  PathConfig.login()
      : root = 'login',
        prjId = null,
        option = null,
        folderId = null,
        fileId = null,
        detail = false;

  // User settings page
  bool get isSettings => root != null && root == 'settings';
  PathConfig.settings()
      : root = 'settings',
        prjId = null,
        option = null,
        folderId = null,
        fileId = null,
        detail = false;

  // Add project page
  bool get isAdd => root != null && root == 'add';
  PathConfig.add()
      : root = 'add',
        prjId = null,
        option = null,
        folderId = null,
        fileId = null,
        detail = false;

  // List of projects
  bool get isProjects => root != null && root == 'projects' && detail == false;
  PathConfig.projects()
      : root = 'projects',
        prjId = null,
        option = null,
        folderId = null,
        fileId = null,
        detail = false;

  // Project detail page
  bool get isProject => root != null && root == 'projects' && detail == true && option == null;
  PathConfig.project(this.prjId)
      : root = 'projects',
        option = null,
        folderId = null,
        fileId = null,
        detail = true;

  // Project permissions page
  PathConfig.permissions(this.prjId)
      : root = 'projects',
        option = 'permissions',
        folderId = null,
        fileId = null,
        detail = true;

  // Project settings page (lang, name)
  PathConfig.options(this.prjId)
      : root = 'projects',
        option = 'settings',
        folderId = null,
        fileId = null,
        detail = true;

  // List of folders page
  PathConfig.folders(this.prjId, this.folderId)
      : root = 'projects',
        option = 'folder',
        fileId = null,
        detail = false;

  // Folder settings page (name, git url)
  PathConfig.folder(this.prjId, this.folderId)
      : root = 'projects',
        option = 'folder',
        fileId = null,
        detail = true;

  // Folder files list
  PathConfig.files(this.prjId, this.folderId)
      : root = 'projects',
        option = 'folder',
        fileId = null,
        detail = false;

  // File settings page
  PathConfig.file(this.prjId, this.folderId, this.fileId)
      : root = 'projects',
        option = 'folder',
        detail = true;

  // File translate page
  PathConfig.translates(this.fileId)
      : root = 'translate',
        prjId = null,
        option = null,
        folderId = null,
        detail = false;

  // 404
  bool get isUnknown => root != null && root == 'unknown';
  PathConfig.unknown()
      : root = 'unknown',
        prjId = null,
        option = null,
        folderId = null,
        fileId = null,
        detail = false;
}
