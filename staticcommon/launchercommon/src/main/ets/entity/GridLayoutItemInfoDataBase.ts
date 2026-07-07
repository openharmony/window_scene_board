/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import GridLayoutItemBuilder from '../bean/GridLayoutItemBuilder';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import GridLayoutItemDbBuilder from './GridLayoutItemDbBuilder';
import type rdb from '@ohos.data.relationalStore';
import { CommonConstants } from '../constants/CommonConstants';
import { commonBundleManager, LightOutdoorConfig } from '@ohos/frameworkwrapper';
import { GridLayoutInfoEnums } from '../db/column/GridLayoutInfoColumns';
import { OverflowFormInfoUtil } from '../utils/OverflowFormInfoUtil';

const FORM_TRANSPARENT: string = '1';

/**
 * Item info of GridLayoutInfo item for database.
 */
export default class GridLayoutItemInfoDataBase {
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
   * GridLayoutInfo: 文件唯一标识符
   */
  public ino: string | undefined;

  /**
   * GridLayoutInfo: file type
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
  public page: number | undefined;

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
   * GridLayoutInfo: kindId
   */
  public kindId: number | undefined;

  /**
   * GridLayoutInfo: download_progress
   */
  public downloadProgress: number = 0;

  /**
   * GridLayoutInfo: app_status
   */
  public appStatus: number | undefined = 0;

  /**
   * GridLayoutInfo: caller_name
   */
  public callerName: string | undefined;

  /**
   * GridLayoutInfo: appIndex
   */
  public appIndex: number | undefined;

  /**
   * GridLayoutInfo: shortcutId
   */
  public shortcutId?: string;

  /**
   * GridLayoutInfo: intent
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

  public targetFormData?: string | undefined;

  /**
   * GridLayoutInfo: screenId
   */
  public screenId: number | undefined;

  constructor() {
  }

  setInfo(gridLayoutItemBuilder: GridLayoutItemDbBuilder): void {
    if (gridLayoutItemBuilder) {
      this.id = gridLayoutItemBuilder.id;
      this.infoId = gridLayoutItemBuilder.infoId;
      this.infoName = gridLayoutItemBuilder.infoName;
      this.uri = gridLayoutItemBuilder.uri;
      this.ino = gridLayoutItemBuilder.ino;
      this.fileType = gridLayoutItemBuilder.fileType;
      this.container = gridLayoutItemBuilder.container;
      this.typeId = gridLayoutItemBuilder.typeId;
      this.width = gridLayoutItemBuilder.width;
      this.height = gridLayoutItemBuilder.height;
      this.page = gridLayoutItemBuilder.pageIndex;
      this.column = gridLayoutItemBuilder.column;
      this.row = gridLayoutItemBuilder.row;
      this.portraitPageIndex = gridLayoutItemBuilder.portraitPageIndex;
      this.portraitColumn = gridLayoutItemBuilder.portraitColumn;
      this.portraitRow = gridLayoutItemBuilder.portraitRow;
      this.portraitWidth = gridLayoutItemBuilder.portraitWidth;
      this.portraitHeight = gridLayoutItemBuilder.portraitHeight;
      this.landscapePageIndex = gridLayoutItemBuilder.landscapePageIndex;
      this.landscapeColumn = gridLayoutItemBuilder.landscapeColumn;
      this.landscapeRow = gridLayoutItemBuilder.landscapeRow;
      this.landscapeWidth = gridLayoutItemBuilder.landscapeWidth;
      this.landscapeHeight = gridLayoutItemBuilder.landscapeHeight;
      this.bundleName = gridLayoutItemBuilder.bundleName;
      this.moduleName = gridLayoutItemBuilder.moduleName;
      this.abilityName = gridLayoutItemBuilder.abilityName;
      this.appIconId = gridLayoutItemBuilder.appIconId;
      this.appLabelId = gridLayoutItemBuilder.appLabelId;
      this.iconResource = gridLayoutItemBuilder.iconResource;
      this.kindId = gridLayoutItemBuilder.kindId;
      this.extend1 = gridLayoutItemBuilder.extend1;
      this.extend2 = gridLayoutItemBuilder.extend2;
      this.userId = gridLayoutItemBuilder.userId;
      this.downloadProgress = gridLayoutItemBuilder.downloadProgress ?? 0;
      this.appStatus = gridLayoutItemBuilder.appStatus;
      this.callerName = gridLayoutItemBuilder.callerName;
      this.appIndex = gridLayoutItemBuilder.appIndex ?? 0;
      this.shortcutId = gridLayoutItemBuilder.shortcutId ?? '';
      this.intent = gridLayoutItemBuilder.intent ?? '';
      this.size = gridLayoutItemBuilder.size ?? 0;
      this.ctime = gridLayoutItemBuilder.ctime ?? 0;
      this.mtime = gridLayoutItemBuilder.mtime ?? 0;
      this.targetFormData = gridLayoutItemBuilder.targetFormData ?? '';
      this.screenId = gridLayoutItemBuilder.screenId ?? 0;
    }
  }

  toValuesBucket(): rdb.ValuesBucket {
    return {
      [GridLayoutInfoEnums.USER_ID]: this.userId,
      [GridLayoutInfoEnums.INFO_ID]: this.infoId,
      [GridLayoutInfoEnums.INFO_NAME]: this.infoName,
      [GridLayoutInfoEnums.URI]: this.uri,
      [GridLayoutInfoEnums.FILE_INO]: this.ino,
      [GridLayoutInfoEnums.FILE_TYPE]: this.fileType,
      [GridLayoutInfoEnums.CONTAINER]: this.container,
      [GridLayoutInfoEnums.TYPE_ID]: this.typeId,
      [GridLayoutInfoEnums.WIDTH]: this.width,
      [GridLayoutInfoEnums.HEIGHT]: this.height,
      [GridLayoutInfoEnums.PAGE_INDEX]: this.page,
      [GridLayoutInfoEnums.COLUMN]: this.column,
      [GridLayoutInfoEnums.ROW]: this.row,
      [GridLayoutInfoEnums.PORTRAIT_PAGE_INDEX]: this.portraitPageIndex,
      [GridLayoutInfoEnums.PORTRAIT_COLUMN]: this.portraitColumn,
      [GridLayoutInfoEnums.PORTRAIT_ROW]: this.portraitRow,
      [GridLayoutInfoEnums.PORTRAIT_WIDTH]: this.portraitWidth,
      [GridLayoutInfoEnums.PORTRAIT_HEIGHT]: this.portraitHeight,
      [GridLayoutInfoEnums.LANDSCAPE_PAGE_INDEX]: this.landscapePageIndex,
      [GridLayoutInfoEnums.LANDSCAPE_COLUMN]: this.landscapeColumn,
      [GridLayoutInfoEnums.LANDSCAPE_ROW]: this.landscapeRow,
      [GridLayoutInfoEnums.LANDSCAPE_WIDTH]: this.landscapeWidth,
      [GridLayoutInfoEnums.LANDSCAPE_HEIGHT]: this.landscapeHeight,
      [GridLayoutInfoEnums.APP_ICON_ID]: this.appIconId,
      [GridLayoutInfoEnums.APP_LABEL_ID]: this.appLabelId,
      [GridLayoutInfoEnums.BUNDLE_NAME]: this.bundleName,
      [GridLayoutInfoEnums.MODULE_NAME]: this.moduleName,
      [GridLayoutInfoEnums.ABILITY_NAME]: this.abilityName,
      [GridLayoutInfoEnums.ICON_RESOURCE]: this.iconResource,
      [GridLayoutInfoEnums.KIND_ID]: this.kindId,
      [GridLayoutInfoEnums.EXTEND1]: this.extend1,
      [GridLayoutInfoEnums.EXTEND2]: this.extend2,
      [GridLayoutInfoEnums.DOWNLOAD_PROGRESS]: this.downloadProgress,
      [GridLayoutInfoEnums.APP_STATUS]: this.appStatus,
      [GridLayoutInfoEnums.CALLER_NAME]: this.callerName,
      [GridLayoutInfoEnums.APP_INDEX]: this.appIndex ?? 0,
      [GridLayoutInfoEnums.SHORTCUT_ID]: this.shortcutId ?? '',
      [GridLayoutInfoEnums.INTENT]: this.intent ?? '',
      [GridLayoutInfoEnums.FILE_SIZE]: this.size ?? 0,
      [GridLayoutInfoEnums.FILE_CREATE_TIME]: this.ctime ?? 0,
      [GridLayoutInfoEnums.FILE_MODIFICATION_TIME]: this.mtime ?? 0,
      [GridLayoutInfoEnums.TARGET_FORM_DATA]: this.targetFormData ?? '',
      [GridLayoutInfoEnums.SCREEN_ID]: this.screenId ?? 0,
    };
  }

  toGridLayoutItemInfo(): GridLayoutItemInfo {
    let gridlayoutItemBuilder = new GridLayoutItemBuilder(this.id ?? 0);
    if (this.typeId === CommonConstants.TYPE_CARD) {
      this.fillCardInfo(gridlayoutItemBuilder);
    } else if (this.typeId === CommonConstants.TYPE_FOLDER || this.typeId === CommonConstants.TYPE_REGION_FOLDER) {
      this.fillFolderInfo(gridlayoutItemBuilder);
    } else if (this.typeId === CommonConstants.TYPE_APP || this.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      this.fillAppInfo(gridlayoutItemBuilder);
    } else if (this.typeId === CommonConstants.TYPE_FILE_FOLDER || this.typeId === CommonConstants.TYPE_REGION_FOLDER) {
      this.fillFileFolderInfo(gridlayoutItemBuilder);
    } else if (this.typeId === CommonConstants.TYPE_FORM_STACK) {
      gridlayoutItemBuilder.setFormStackId(this.infoId);
    }
    this.fillBaseAreaInfo(gridlayoutItemBuilder);
    this.fillBaseItemInfo(gridlayoutItemBuilder);
    gridlayoutItemBuilder.setExtend1(this.extend1);
    gridlayoutItemBuilder.setExtend2(this.extend2);
    gridlayoutItemBuilder.setExtend3(0);
    if (this.typeId === CommonConstants.TYPE_FILE_FOLDER) {
      gridlayoutItemBuilder.setKeyName(this.ino);
    } else if (this.typeId === CommonConstants.TYPE_REGION_FOLDER || this.typeId === CommonConstants.TYPE_FOLDER) {
      gridlayoutItemBuilder.setKeyName(this.infoId);
    } else {
      gridlayoutItemBuilder.setKeyName(`${this.bundleName}${this.abilityName}${this.moduleName}${this.appIndex ?? 0}` +
        `${this.shortcutId ?? ''}`);
    }
    return gridlayoutItemBuilder.buildGridLayoutItem();
  }

  private fillCardInfo(gridlayoutItemBuilder: GridLayoutItemBuilder): void {
    gridlayoutItemBuilder.setCardId(this.infoId === undefined ? '' : this.infoId); // 没定义就是预置卡片，cardId为0
    gridlayoutItemBuilder.setCardName(this.infoName);
    gridlayoutItemBuilder.setFormConfigAbility(this.uri);
    gridlayoutItemBuilder.setIsTransparent(this.extend2 === FORM_TRANSPARENT);
    gridlayoutItemBuilder.setTargetFormData(this.targetFormData);
    let gameCard = OverflowFormInfoUtil.parseLiveFormCardInfo(this.intent);
    if (gameCard) {
      gridlayoutItemBuilder.setGameCardInfo(gameCard);
    }
  }

  private fillFolderInfo(gridlayoutItemBuilder: GridLayoutItemBuilder): void {
    gridlayoutItemBuilder.setFolderId(this.infoId);
    gridlayoutItemBuilder.setFolderName(this.infoName);
  }

  private fillAppInfo(gridlayoutItemBuilder: GridLayoutItemBuilder): void {
    gridlayoutItemBuilder.setAppName(this.infoName);
    gridlayoutItemBuilder.setAppIndex(this.appIndex ?? 0);
    gridlayoutItemBuilder.setShortcutId(this.shortcutId);
  }

  private fillFileFolderInfo(gridlayoutItemBuilder: GridLayoutItemBuilder): void {
    gridlayoutItemBuilder.setFileFolderName(this.infoName);
    gridlayoutItemBuilder.setSize(this.size ?? 0);
    gridlayoutItemBuilder.setCtime(this.ctime ?? 0);
    gridlayoutItemBuilder.setMtime(this.mtime ?? 0);
  }

  private fillBaseAreaInfo(gridlayoutItemBuilder: GridLayoutItemBuilder): void {
    gridlayoutItemBuilder.setArea(`${this.width},${this.height}`);
    gridlayoutItemBuilder.setAreaType(CommonConstants.TYPE_AREA_DESKTOP);
    gridlayoutItemBuilder.setPage(this.page);
    gridlayoutItemBuilder.setColumn(this.column);
    gridlayoutItemBuilder.setRow(this.row);
    gridlayoutItemBuilder.setPortraitPageIndex(this.portraitPageIndex);
    gridlayoutItemBuilder.setPortraitColumn(this.portraitColumn);
    gridlayoutItemBuilder.setPortraitRow(this.portraitRow);
    gridlayoutItemBuilder.setPortraitArea(this.portraitWidth, this.portraitHeight);
    gridlayoutItemBuilder.setLandscapePageIndex(this.landscapePageIndex);
    gridlayoutItemBuilder.setLandscapeColumn(this.landscapeColumn);
    gridlayoutItemBuilder.setLandscapeRow(this.landscapeRow);
    gridlayoutItemBuilder.setLandscapeArea(this.landscapeWidth, this.landscapeHeight);
  }

  private fillBaseItemInfo(gridlayoutItemBuilder: GridLayoutItemBuilder): void {
    gridlayoutItemBuilder.setIntent(this.intent);
    gridlayoutItemBuilder.setKindId(this.kindId);
    gridlayoutItemBuilder.setContainer(this.container);
    gridlayoutItemBuilder.setBadgeNumber(0);
    gridlayoutItemBuilder.setUri(this.uri);
    gridlayoutItemBuilder.setIno(this.ino ?? '');
    gridlayoutItemBuilder.setFileType(this.fileType ?? 0);
    gridlayoutItemBuilder.setTypeId(this.typeId);
    gridlayoutItemBuilder.setBundleName(this.bundleName);
    gridlayoutItemBuilder.setAbilityName(this.abilityName);
    gridlayoutItemBuilder.setModuleName(this.moduleName);
    gridlayoutItemBuilder.setAppIconId(this.appIconId ?? 0);
    gridlayoutItemBuilder.setAppLabelId(this.appLabelId ?? 0);
    gridlayoutItemBuilder.setDownloadProgress(this.downloadProgress);
    gridlayoutItemBuilder.setAppStatus(this.appStatus ?? 0);
    gridlayoutItemBuilder.setIconResource(this.iconResource);
    gridlayoutItemBuilder.setCallerName(this.callerName);
    gridlayoutItemBuilder.setInfoId(this.infoId);
    gridlayoutItemBuilder.setScreenId(this.screenId);
  }

  public static toGridLayoutItemInfoDB(item: GridLayoutItemInfo): GridLayoutItemInfoDataBase {
    let gridlayoutItemDbBuilder = new GridLayoutItemDbBuilder(0);
    if (!item) {
      return gridlayoutItemDbBuilder.buildGridLayoutItemDB();
    }
    gridlayoutItemDbBuilder.setUri(item.uri);
    gridlayoutItemDbBuilder.setExtend2(item.extend2);
    GridLayoutItemInfoDataBase.setTypeRelativeInfo(item, gridlayoutItemDbBuilder);
    gridlayoutItemDbBuilder.setIno(item.ino);
    gridlayoutItemDbBuilder.setFileType(item.fileType);
    gridlayoutItemDbBuilder.setContainer(item.container === undefined ?
      CommonConstants.CONTAINER_DESKTOP : item.container);
    gridlayoutItemDbBuilder.setTypeId(item.typeId);
    if (item.area && item.area.length === CommonConstants.AREA_LENGTH) {
      gridlayoutItemDbBuilder.setWidth(item.area[0]);
      gridlayoutItemDbBuilder.setHeight(item.area[1]);
    }
    GridLayoutItemInfoDataBase.fillDBBaseAreaInfo(gridlayoutItemDbBuilder, item);
    GridLayoutItemInfoDataBase.fillDBBaseItemInfo(gridlayoutItemDbBuilder, item);
    return gridlayoutItemDbBuilder.buildGridLayoutItemDB();
  }

  private static fillDBBaseAreaInfo(gridlayoutItemDbBuilder: GridLayoutItemDbBuilder, item: GridLayoutItemInfo): void {
    gridlayoutItemDbBuilder.setPageIndex(item.page);
    gridlayoutItemDbBuilder.setColumn(item.column);
    gridlayoutItemDbBuilder.setRow(item.row);
    gridlayoutItemDbBuilder.setPortraitPageIndex(item.portraitPage);
    gridlayoutItemDbBuilder.setPortraitColumn(item.portraitColumn);
    gridlayoutItemDbBuilder.setPortraitRow(item.portraitRow);
    gridlayoutItemDbBuilder.setPortraitWidth(item.portraitArea?.[0] ?? -1);
    gridlayoutItemDbBuilder.setPortraitHeight(item.portraitArea?.[1] ?? -1);
    gridlayoutItemDbBuilder.setLandscapePageIndex(item.landscapePage);
    gridlayoutItemDbBuilder.setLandscapeColumn(item.landscapeColumn);
    gridlayoutItemDbBuilder.setLandscapeRow(item.landscapeRow);
    gridlayoutItemDbBuilder.setLandscapeWidth(item.landscapeArea?.[0] ?? -1);
    gridlayoutItemDbBuilder.setLandscapeHeight(item.landscapeArea?.[1] ?? -1);
  }

  private static fillDBBaseItemInfo(gridlayoutItemDbBuilder: GridLayoutItemDbBuilder, item: GridLayoutItemInfo): void {
    gridlayoutItemDbBuilder.setBundleName(item.bundleName);
    gridlayoutItemDbBuilder.setModuleName(item.moduleName);
    gridlayoutItemDbBuilder.setAbilityName(item.abilityName);
    gridlayoutItemDbBuilder.setAppIconId(item.appIconId);
    gridlayoutItemDbBuilder.setAppLabelId(item.appLabelId);
    gridlayoutItemDbBuilder.setKindId(item.kindId);
    gridlayoutItemDbBuilder.setIconResource(item.iconResource);
    gridlayoutItemDbBuilder.setExtend1(item.extend1);
    gridlayoutItemDbBuilder.setUserId(commonBundleManager.getUserId());
    gridlayoutItemDbBuilder.setDownloadProgress(item.downloadProgress);
    gridlayoutItemDbBuilder.setAppStatus(item.appStatus ?? 0);
    gridlayoutItemDbBuilder.setCallerName(item.callerName);
    gridlayoutItemDbBuilder.setAppIndex(item.appIndex ?? 0);
    gridlayoutItemDbBuilder.setShortcutId(item.shortcutId ?? '');
    gridlayoutItemDbBuilder.setIntent(item.intent ?? '');
    gridlayoutItemDbBuilder.setSize(item.size ?? 0);
    gridlayoutItemDbBuilder.setCtime(item.ctime ?? 0);
    gridlayoutItemDbBuilder.setMtime(item.mtime ?? 0);
    gridlayoutItemDbBuilder.setScreenId(item.screenId ?? 0);
  }

  private static setTypeRelativeInfo(item: GridLayoutItemInfo, gridlayoutItemDbBuilder: GridLayoutItemDbBuilder): void {
    if (item.typeId === CommonConstants.TYPE_CARD) {
      if (item.cardId) {
        gridlayoutItemDbBuilder.setInfoId(item.cardId);
      }
      gridlayoutItemDbBuilder.setInfoName(item.cardName);
      gridlayoutItemDbBuilder.setUri(item.formConfigAbility);
      gridlayoutItemDbBuilder.setExtend2(item?.isTransparent ? '1' : '0');
    } else if (item.typeId === CommonConstants.TYPE_FOLDER || item.typeId === CommonConstants.TYPE_REGION_FOLDER) {
      gridlayoutItemDbBuilder.setInfoName(item.folderName);
      gridlayoutItemDbBuilder.setInfoId(item.folderId);
    } else if (item.typeId === CommonConstants.TYPE_APP || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      gridlayoutItemDbBuilder.setInfoName(item.appName ?? '');
      gridlayoutItemDbBuilder.setInfoId(item.infoId);
    } else if (item.typeId === CommonConstants.TYPE_FILE_FOLDER) {
      gridlayoutItemDbBuilder.setInfoName(item.fileFolderName);
      gridlayoutItemDbBuilder.setInfoId(item.infoId);
    } else if (item.typeId === CommonConstants.TYPE_FORM_STACK) {
      gridlayoutItemDbBuilder.setInfoId(item.formStackId);
    } else if (item.typeId === CommonConstants.TYPE_ADD) {
      if (LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
        gridlayoutItemDbBuilder.setInfoId(CommonConstants.LIGHT_OUTDOOR_ADD_ICON_INFO_ID);
      }
    }
  }
}
