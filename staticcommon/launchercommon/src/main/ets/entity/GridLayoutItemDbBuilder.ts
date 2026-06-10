/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import GridLayoutInfoColumns from '../db/column/GridLayoutInfoColumns';
import GridLayoutItemInfoDataBase from './GridLayoutItemInfoDataBase';
import type GridLayoutItemInfo from './GridLayoutItemInfoDataBase';
import type rdb from '@ohos.data.relationalStore';
import GridLayoutItemBuilder from '../bean/GridLayoutItemBuilder';

/**
 * Item info of GridLayoutInfo item builder
 */
export default class GridLayoutItemDbBuilder {
  /**
   * GridLayoutInfo: id 主键
   */
  public id: number | undefined;

  /**
   * GridLayoutInfo: info id 元素标识id
   */
  public infoId: string | undefined;

  /**
   * GridLayoutInfo: info name 元素名称
   */
  public infoName: string | undefined;

  /**
   * GridLayoutInfo: uri
   */
  public uri: string | undefined;

  /**
   * GridLayoutInfo: Unique identifier of file
   */
  public ino: string | undefined;

  /**
   * GridLayoutInfo: type of file
   */
  public fileType: number | undefined;

  /**
   * GridLayoutInfo: bigfolder id 元素所在位置（工作区，Dock区，文件夹）
   * Not in bigfolder: - 100
   * In a bigfolder: ID of the bigfolder.
   */
  public container: number | undefined;

  /**
   * GridLayoutInfo: type id 元素类型
   */
  public typeId: number | undefined;

  /**
   * GridLayoutInfo: width 网格内所占列数
   */
  public width: number | undefined;

  /**
   * GridLayoutInfo: height 网格内所占行数
   */
  public height: number | undefined;

  /**
   * GridLayoutInfo: page index 桌面页数索引（0 ~ n-1）
   */
  public pageIndex: number | undefined;

  /**
   * GridLayoutInfo: column of positions 网格上起始列
   */
  public column: number | undefined;

  /**
   * GridLayoutInfo: row of positions 网格上起始行
   */
  public row: number | undefined;

  /**
   * for lazy rotate
   */
  public portraitPageIndex: number | undefined;

  /**
   * for lazy rotate
   */
  public portraitColumn: number | undefined;

  /**
   * for lazy rotate
   */
  public portraitRow: number | undefined;

  /**
   * for lazy rotate
   */
  public portraitWidth: number | undefined;

  /**
   * for lazy rotate
   */
  public portraitHeight: number | undefined;

  /**
   * for lazy rotate
   */
  public landscapePageIndex: number | undefined;

  /**
   * for lazy rotate
   */
  public landscapeColumn: number | undefined;

  /**
   * for lazy rotate
   */
  public landscapeRow: number | undefined;

  /**
   * for lazy rotate
   */
  public landscapeWidth: number | undefined;

  /**
   * for lazy rotate
   */
  public landscapeHeight: number | undefined;

  /**
   * GridLayoutInfo bundle name. 包名
   */
  public bundleName: string | undefined;

  /**
   * GridLayoutInfo module name. 模块名
   */
  public moduleName: string | undefined;

  /**
   * GridLayoutInfo ability name. Ability名称
   */
  public abilityName: string | undefined;

  /**
   * GridLayoutInfo: app icon id 应用图标id
   */
  public appIconId: number | undefined;

  /**
   * GridLayoutInfo: app label id 应用label id
   */
  public appLabelId: number | undefined;

  /**
   * GridLayoutInfo icon resource.
   */
  public iconResource: string | undefined;

  /**
   * GridLayoutInfo layout info. 子布局：大文件夹中包含的app信息
   */
  public layoutInfo: GridLayoutItemInfo[] | undefined;

  /**
   * GridLayoutItemInfo: row of positons
   */
  public kindId: number | undefined;

  /**
   * GridLayoutInfo: extend1
   */
  public extend1: string | undefined;

  /**
   * GridLayoutInfo: extend2
   */
  public extend2: string | undefined;

  /**
   * GridLayoutInfo: user id 用户id
   */
  public userId: number | undefined;

  /**
   * GridLayoutInfo: download progress 下载进度
   */
  public downloadProgress: number | undefined;

  /**
   * GridLayoutInfo: app status 应用状态（下载中、暂停等）
   */
  public appStatus: number | undefined;

  /**
   * 任务创建者的名字
   */
  public callerName?: string | undefined;

  /**
   * GridLayoutInfo: appIndex 应用分身id
   */
  public appIndex: number | undefined;

  /**
   * GridLayoutInfo: shortcutId 快捷方式id
   */
  public shortcutId?: string;

  /**
   * GridLayoutInfo: intent 特殊应用标识
   */
  public intent?: string;

  /**
   * GridLayoutInfo: size of file/folder
   */
  public size: number | undefined;

  /**
   * GridLayoutInfo: Create time of file/folder
   */
  public ctime: number | undefined;

  /**
   * GridLayoutInfo: Modification time of file/folder
   */
  public mtime: number | undefined;

  public screenId?: number | undefined;

  public targetFormData?: string | undefined;

  constructor(id: number) {
    this.id = id;
  }

  static fromResultSet(resultSet: rdb.ResultSet): GridLayoutItemDbBuilder {
    let gridlayoutItemBuilder = new GridLayoutItemDbBuilder(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.ID)));
    gridlayoutItemBuilder.setInfoId(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.INFO_ID)));
    gridlayoutItemBuilder.setInfoName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.INFO_NAME)));
    gridlayoutItemBuilder.setUri(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.URI)));
    gridlayoutItemBuilder.setIno(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.FILE_INO)));
    gridlayoutItemBuilder.setFileType(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.FILE_TYPE)));
    gridlayoutItemBuilder.setContainer(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.CONTAINER)));
    gridlayoutItemBuilder.setTypeId(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.TYPE_ID)));
    gridlayoutItemBuilder.setWidth(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.WIDTH)));
    gridlayoutItemBuilder.setHeight(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.HEIGHT)));
    gridlayoutItemBuilder.setPageIndex(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.PAGE_INDEX)));
    gridlayoutItemBuilder.setColumn(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.COLUMN)));
    gridlayoutItemBuilder.setRow(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.ROW)));
    gridlayoutItemBuilder.setBundleName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.BUNDLE_NAME)));
    gridlayoutItemBuilder.setModuleName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.MODULE_NAME)));
    gridlayoutItemBuilder.setAbilityName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ABILITY_NAME)));
    gridlayoutItemBuilder.setAppIconId(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_ICON_ID)));
    gridlayoutItemBuilder.setAppLabelId(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_LABEL_ID)));
    gridlayoutItemBuilder.setIconResource(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ICON_RESOURCE)));
    gridlayoutItemBuilder.setKindId(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.KIND_ID)));
    gridlayoutItemBuilder.setExtend1(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.EXTEND1)));
    gridlayoutItemBuilder.setExtend2(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.EXTEND2)));
    gridlayoutItemBuilder.setUserId(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.USER_ID)));
    gridlayoutItemBuilder.setDownloadProgress(resultSet.getDouble(resultSet.getColumnIndex(GridLayoutInfoColumns.DOWNLOAD_PROGRESS)));
    gridlayoutItemBuilder.setAppStatus(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_STATUS)));
    gridlayoutItemBuilder.setCallerName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.CALLER_NAME)));
    gridlayoutItemBuilder.setAppIndex(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_INDEX)));
    gridlayoutItemBuilder.setShortcutId(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.SHORTCUT_ID)));
    gridlayoutItemBuilder.setIntent(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.INTENT)));
    let filSizeIndex: number = GridLayoutItemDbBuilder.getColumnIndex(resultSet, GridLayoutInfoColumns.FILE_SIZE);
    if (filSizeIndex > 0) {
      gridlayoutItemBuilder.setSize(resultSet.getLong(filSizeIndex));
      gridlayoutItemBuilder.setCtime(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.FILE_CREATE_TIME)));
      gridlayoutItemBuilder.setMtime(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.FILE_MODIFICATION_TIME)));
    } else {
      gridlayoutItemBuilder.setSize(0);
      gridlayoutItemBuilder.setCtime(0);
      gridlayoutItemBuilder.setMtime(0);
    }
    let targetFormDataIndex: number = GridLayoutItemDbBuilder.getColumnIndex(resultSet, GridLayoutInfoColumns.TARGET_FORM_DATA);
    if (targetFormDataIndex > 0) {
      gridlayoutItemBuilder.setTargetFormData(resultSet.getString(targetFormDataIndex));
    } else {
      gridlayoutItemBuilder.setTargetFormData('');
    }
    let portraitPage: number = resultSet.getColumnIndex(GridLayoutInfoColumns.PORTRAIT_PAGE_INDEX);
    let portraitColumn: number = resultSet.getColumnIndex(GridLayoutInfoColumns.PORTRAIT_COLUMN);
    let portraitRow: number = resultSet.getColumnIndex(GridLayoutInfoColumns.PORTRAIT_ROW);
    let portraitWidth: number = resultSet.getColumnIndex(GridLayoutInfoColumns.PORTRAIT_WIDTH);
    let portraitHeight: number = resultSet.getColumnIndex(GridLayoutInfoColumns.PORTRAIT_HEIGHT);
    let landscapePage: number = resultSet.getColumnIndex(GridLayoutInfoColumns.LANDSCAPE_PAGE_INDEX);
    let landscapeColumn: number = resultSet.getColumnIndex(GridLayoutInfoColumns.LANDSCAPE_COLUMN);
    let landscapeRow: number = resultSet.getColumnIndex(GridLayoutInfoColumns.LANDSCAPE_ROW);
    let landscapeWidth: number = resultSet.getColumnIndex(GridLayoutInfoColumns.LANDSCAPE_WIDTH);
    let landscapeHeight: number = resultSet.getColumnIndex(GridLayoutInfoColumns.LANDSCAPE_HEIGHT);
    let screenId: number = resultSet.getColumnIndex(GridLayoutInfoColumns.SCREEN_ID);
    gridlayoutItemBuilder.setPortraitPageIndex(portraitPage > 0 ? resultSet.getLong(portraitPage) : NaN);
    gridlayoutItemBuilder.setPortraitColumn(portraitColumn > 0 ? resultSet.getLong(portraitColumn) : NaN);
    gridlayoutItemBuilder.setPortraitRow(portraitRow > 0 ? resultSet.getLong(portraitRow) : NaN);
    gridlayoutItemBuilder.setPortraitWidth(portraitWidth > 0 ? resultSet.getLong(portraitWidth) : NaN);
    gridlayoutItemBuilder.setPortraitHeight(portraitHeight > 0 ? resultSet.getLong(portraitHeight) : NaN);
    gridlayoutItemBuilder.setLandscapePageIndex(landscapePage > 0 ? resultSet.getLong(landscapePage) : NaN);
    gridlayoutItemBuilder.setLandscapeColumn(landscapeColumn > 0 ? resultSet.getLong(landscapeColumn) : NaN);
    gridlayoutItemBuilder.setLandscapeRow(landscapeRow > 0 ? resultSet.getLong(landscapeRow) : NaN);
    gridlayoutItemBuilder.setLandscapeWidth(landscapeWidth > 0 ? resultSet.getLong(landscapeWidth) : NaN);
    gridlayoutItemBuilder.setLandscapeHeight(landscapeHeight > 0 ? resultSet.getLong(landscapeHeight) : NaN);
    gridlayoutItemBuilder.setScreenId(screenId > 0 ? resultSet.getLong(screenId) : NaN);
    return gridlayoutItemBuilder;
  }

  static getColumnIndex(resultSet: rdb.ResultSet, columnName: string):number {
    let index: number = -1;
    try {
      index = resultSet?.getColumnIndex(columnName);
    } catch (error) {
      index = -1;
    }
    return index;
  }

  public setInfoId(infoId: string | undefined): GridLayoutItemDbBuilder {
    this.infoId = infoId;
    return this;
  }

  public setInfoName(infoName: string | undefined): GridLayoutItemDbBuilder {
    this.infoName = infoName;
    return this;
  }

  public setUri(uri: string | undefined): GridLayoutItemDbBuilder {
    this.uri = uri;
    return this;
  }

  public setIno(ino: string | undefined): GridLayoutItemDbBuilder {
    this.ino = ino;
    return this;
  }

  public setFileType(fileType: number | undefined): GridLayoutItemDbBuilder {
    this.fileType = fileType;
    return this;
  }

  public setContainer(container: number | undefined): GridLayoutItemDbBuilder {
    this.container = container;
    return this;
  }

  public setTypeId(typeId: number | undefined): GridLayoutItemDbBuilder {
    this.typeId = typeId;
    return this;
  }

  public setWidth(width: number): GridLayoutItemDbBuilder {
    this.width = width;
    return this;
  }

  public setHeight(height: number): GridLayoutItemDbBuilder {
    this.height = height;
    return this;
  }

  public setPageIndex(pageIndex: number | undefined): GridLayoutItemDbBuilder {
    this.pageIndex = pageIndex;
    return this;
  }

  public setColumn(column: number | undefined): GridLayoutItemDbBuilder {
    this.column = column;
    return this;
  }

  public setRow(row: number | undefined): GridLayoutItemDbBuilder {
    this.row = row;
    return this;
  }

  public setPortraitPageIndex(pageIndex: number | undefined): GridLayoutItemDbBuilder {
    this.portraitPageIndex = pageIndex;
    return this;
  }

  public setPortraitColumn(column: number | undefined): GridLayoutItemDbBuilder {
    this.portraitColumn = column;
    return this;
  }

  public setPortraitRow(row: number | undefined): GridLayoutItemDbBuilder {
    this.portraitRow = row;
    return this;
  }

  public setPortraitWidth(width: number): GridLayoutItemDbBuilder {
    this.portraitWidth = width;
    return this;
  }

  public setPortraitHeight(height: number): GridLayoutItemDbBuilder {
    this.portraitHeight = height;
    return this;
  }

  public setLandscapePageIndex(pageIndex: number | undefined): GridLayoutItemDbBuilder {
    this.landscapePageIndex = pageIndex;
    return this;
  }

  public setLandscapeColumn(column: number | undefined): GridLayoutItemDbBuilder {
    this.landscapeColumn = column;
    return this;
  }

  public setLandscapeRow(row: number | undefined): GridLayoutItemDbBuilder {
    this.landscapeRow = row;
    return this;
  }

  public setLandscapeWidth(width: number): GridLayoutItemDbBuilder {
    this.landscapeWidth = width;
    return this;
  }

  public setLandscapeHeight(height: number): GridLayoutItemDbBuilder {
    this.landscapeHeight = height;
    return this;
  }

  public setBundleName(bundleName: string): GridLayoutItemDbBuilder {
    this.bundleName = bundleName;
    return this;
  }

  public setModuleName(moduleName: string | undefined): GridLayoutItemDbBuilder {
    this.moduleName = moduleName;
    return this;
  }

  public setAbilityName(abilityName: string): GridLayoutItemDbBuilder {
    this.abilityName = abilityName;
    return this;
  }

  public setAppIconId(appIconId: number): GridLayoutItemDbBuilder {
    this.appIconId = appIconId;
    return this;
  }

  public setAppLabelId(appLabelId: number | undefined): GridLayoutItemDbBuilder {
    this.appLabelId = appLabelId;
    return this;
  }

  public setIconResource(iconResource: string | undefined): GridLayoutItemDbBuilder {
    this.iconResource = iconResource;
    return this;
  }

  public setLayoutInfo(gridLayoutItemInfos: GridLayoutItemInfo[]): GridLayoutItemDbBuilder {
    this.layoutInfo = gridLayoutItemInfos;
    return this;
  }

  public setExtend1(extend1: string | undefined): GridLayoutItemDbBuilder {
    this.extend1 = extend1;
    return this;
  }

  public setKindId(kindId: number | undefined): GridLayoutItemDbBuilder {
    this.kindId = kindId;
    return this;
  }

  public setExtend2(extend2: string | undefined): GridLayoutItemDbBuilder {
    this.extend2 = extend2;
    return this;
  }

  public setUserId(userId: number): GridLayoutItemDbBuilder {
    this.userId = userId;
    return this;
  }

  public setDownloadProgress(progress: number): GridLayoutItemDbBuilder {
    this.downloadProgress = progress;
    return this;
  }

  public setAppStatus(status: number): GridLayoutItemDbBuilder {
    this.appStatus = status;
    return this;
  }

  public setCallerName(callerName: string | undefined): GridLayoutItemDbBuilder {
    this.callerName = callerName;
    return this;
  }

  public setAppIndex(appIndex: number): GridLayoutItemDbBuilder {
    this.appIndex = appIndex;
    return this;
  }

  public setShortcutId(shortcutId: string): GridLayoutItemDbBuilder {
    this.shortcutId = shortcutId;
    return this;
  }

  public setIntent(intent: string): GridLayoutItemDbBuilder {
    this.intent = intent;
    return this;
  }

  public setSize(size: number): GridLayoutItemDbBuilder {
    this.size = size;
    return this;
  }

  public setCtime(Ctime: number): GridLayoutItemDbBuilder {
    this.ctime = Ctime;
    return this;
  }

  public setMtime(Mtime: number): GridLayoutItemDbBuilder {
    this.mtime = Mtime;
    return this;
  }

  public setTargetFormData(targetFormData: string): GridLayoutItemDbBuilder {
    this.targetFormData = targetFormData;
    return this;
  }

  public setScreenId(screenId: number): GridLayoutItemDbBuilder {
    this.screenId = screenId;
    return this;
  }

  buildGridLayoutItemDB(): GridLayoutItemInfoDataBase {
    let info = new GridLayoutItemInfoDataBase();
    info.setInfo(this);
    return info;
  }
}