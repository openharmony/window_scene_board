/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { OverflowFormInfoUtil } from '../utils/OverflowFormInfoUtil';
import { AppItemInfo } from './AppItemInfo';
import { GameCardInfo } from './GameCardInfo';
import GridLayoutInfoColumns from './GridLayoutInfoColumns';
import GridLayoutItemInfo from './GridLayoutItemInfo';
import rdb from '@ohos.data.rdb';

const TAG: string = 'GridLayoutItemBuilder';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
/**
 * Item info of GridLayoutInfo item.
 */
export default class GridLayoutItemBuilder {
  /**
   * GridLayoutItemInfo: id
   */
  public readonly id: number | undefined;

  /**
   * GridLayoutItemInfo: info id 元素标识id
   */
  public infoId?: string;

  /**
   * GridLayoutItemInfo: cardId
   */
  public cardId: string | undefined;

  /**
   * GridLayoutItemInfo: ID of the bigfolder.
   */
  public folderId: string | undefined;

  /**
   * GridLayoutItemInfo: ID of the formstack.
   */
  public formStackId: string | undefined;

  /**
   * GridLayoutItemInfo: bigfolder id
   * Not in bigfolder: - 100
   * In a bigfolder: ID of the bigfolder.
   */
  public container: number | undefined;

  /**
   * GridLayoutItemInfo: bigfolder Name
   */
  public folderName: string | undefined;

  /**
   * GridLayoutItemInfo: badgeNumber
   */
  public badgeNumber: number | undefined;

  /**
   * GridLayoutItemInfo: type  0:app  1:card  3:bigfolder
   */
  public typeId: number | undefined;

  /**
   * GridLayoutItemInfo: file/folder uri
   */
  public uri: string | undefined;

  /**
   * GridLayoutItemInfo: file/folder Unique Identifier
   */
  public ino: string = '';

  /**
   * GridLayoutItemInfo: file/folder type
   */
  public fileType: number = 0;

  /**
   * GridLayoutItemInfo: file/folder name
   */
  public fileFolderName: string | undefined;

  /**
   * GridLayoutItemInfo: area
   */
  public area: number[] | undefined;

  /**
   * GridLayoutItemInfo: areaType
   */
  public areaType: number | undefined;

  /**
   * GridLayoutItemInfo: page
   */
  public page: number | undefined;

  /**
   * GridLayoutItemInfo: column of positons
   */
  public column: number | undefined;

  /**
   * GridLayoutItemInfo: row of positons
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
  public portraitArea: number[] | undefined;

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
  public landscapeArea: number[] | undefined;

  /**
   * GridLayoutItemInfo: bigfolder apps info
   */
  public layoutInfo: AppItemInfo[] | undefined;

  /**
   * Indicates bundleName.
   */
  public bundleName: string | undefined;

  /**
   * Indicates keyName.
   */
  public keyName: string | undefined;

  /**
   * Indicates abilityName.
   */
  public abilityName: string | undefined;

  /**
   * Indicates moduleName.
   */
  public moduleName: string | undefined;

  /**
   * Indicates appIconId.
   */
  public appIconId: number = 0;

  /**
   * Indicates appLabelId.
   */
  public appLabelId: number = 0;

  /**
   * GridLayoutItemInfo: extend1
   */
  public extend1: string | undefined;

  /**
   * GridLayoutItemInfo: extend2
   */
  public extend2: string | undefined;

  /**
   * GridLayoutItemInfo: extend3
   */
  public extend3: number | undefined;

  public formConfigAbility: string | undefined;

  public appName: string | undefined;

  public cardName: string | undefined;

  public iconResource: string | undefined;

  public kindId: number | undefined;

  public downloadProgress: number | undefined;

  public appStatus: number | undefined;

  public callerName: string | undefined;

  /**
   * Is form transparent
   */
  public isTransparent?: boolean = false;

  public shortcutId?: string;

  public appIndex?: number = 0;

  public intent?: string = '';

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

  public gameCardInfo?: GameCardInfo;

  /**
   * 孵化卡片信息
   */
  public targetFormData?: string = '';

  /**
   * 扩展屏ID
   * */
  public screenId?: number = 0;

  constructor(id: number) {
    this.id = id;
  }

  static fromResultSet(resultSet: rdb.ResultSet): GridLayoutItemBuilder {
    if (CheckEmptyUtils.isEmpty(resultSet)) {
      return new GridLayoutItemBuilder(0);
    }
    let gridlayoutItemBuilder = new GridLayoutItemBuilder(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.ID)));
    gridlayoutItemBuilder.setCardId(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.CARD_ID)));
    gridlayoutItemBuilder.setFolderId(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.FOLDER_ID)));
    gridlayoutItemBuilder.setContainer(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.CONTAINER)));
    gridlayoutItemBuilder.setFolderName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.FOLDER_NAME)));
    gridlayoutItemBuilder.setBadgeNumber(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.BADGE_NUMBER)));
    gridlayoutItemBuilder.setFileFolderName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.FILE_FOLDER_NAME)));
    gridlayoutItemBuilder.setUri(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.URI)));
    gridlayoutItemBuilder.setIno(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.FILE_INO)));
    gridlayoutItemBuilder.setFileType(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.FILE_TYPE)));
    gridlayoutItemBuilder.setTypeId(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.TYPE_ID)));
    gridlayoutItemBuilder.setArea(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.AREA)));
    gridlayoutItemBuilder.setPage(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.PAGE)));
    gridlayoutItemBuilder.setColumn(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.COLUMN)));
    gridlayoutItemBuilder.setRow(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.ROW)));
    gridlayoutItemBuilder.setPortraitPageIndex(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.PORTRAIT_PAGE)));
    gridlayoutItemBuilder.setPortraitColumn(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.PORTRAIT_COLUMN)));
    gridlayoutItemBuilder.setPortraitRow(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.PORTRAIT_ROW)));
    gridlayoutItemBuilder.setPortraitArea(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.PORTRAIT_WIDTH)),
      resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.PORTRAIT_HEIGHT)));
    gridlayoutItemBuilder.setLandscapePageIndex(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.LANDSCAPE_PAGE)));
    gridlayoutItemBuilder.setLandscapeColumn(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.LANDSCAPE_COLUMN)));
    gridlayoutItemBuilder.setLandscapeRow(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.LANDSCAPE_ROW)));
    gridlayoutItemBuilder.setLandscapeArea(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.LANDSCAPE_WIDTH)),
      resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.LANDSCAPE_HEIGHT)));
    gridlayoutItemBuilder.setBundleName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.BUNDLE_NAME)));
    gridlayoutItemBuilder.setKeyName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.KEY_NAME)));
    gridlayoutItemBuilder.setAbilityName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ABILITY_NAME)));
    gridlayoutItemBuilder.setModuleName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.MODULE_NAME)));
    gridlayoutItemBuilder.setAppIconId(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APPICON_ID)));
    gridlayoutItemBuilder.setExtend1(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.EXTEND1)));
    gridlayoutItemBuilder.setExtend2(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.EXTEND2)));
    gridlayoutItemBuilder.setExtend3(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.EXTEND3)));
    gridlayoutItemBuilder.setDownloadProgress(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.DOWNLOAD_PROGRESS)));
    gridlayoutItemBuilder.setAppStatus(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_STATUS)));
    gridlayoutItemBuilder.setIconResource(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ICON_RESOURCE)));
    gridlayoutItemBuilder.setCallerName(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.CALLER_NAME)));
    gridlayoutItemBuilder.setAppIndex(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_INDEX)));
    gridlayoutItemBuilder.setIntent(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.INTENT)));
    let cardInfo = OverflowFormInfoUtil.parseLiveFormCardInfo(gridlayoutItemBuilder.intent ?? '');
    if (cardInfo) {
      gridlayoutItemBuilder.setGameCardInfo(cardInfo);
    }
    gridlayoutItemBuilder.setSize(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.FILE_SIZE)));
    gridlayoutItemBuilder.setCtime(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.FILE_CREATE_TIME)));
    gridlayoutItemBuilder.setMtime(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.FILE_MODIFICATION_TIME)));
    gridlayoutItemBuilder.setTargetFormData(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.TARGET_FORM_DATA)));
    gridlayoutItemBuilder.setScreenId(resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.SCREEN_ID)));
    return gridlayoutItemBuilder;
  }

  static buildLayout(resultSet: rdb.ResultSet): AppItemInfo {
    let appItemInfo = new AppItemInfo();
    appItemInfo.appName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_NAME));
    appItemInfo.isSystemApp = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.IS_SYSTEM_APP)) > 0 ? true : false;
    appItemInfo.isUninstallAble = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.IS_UNINSTALLABLE)) > 0 ? true : false;
    appItemInfo.appIconId = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APPICON_ID));
    appItemInfo.appLabelId = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APPLABEL_ID));
    appItemInfo.bundleName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.BUNDLE_NAME));
    appItemInfo.abilityName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ABILITY_NAME));
    appItemInfo.moduleName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.MODULE_NAME));
    appItemInfo.keyName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.KEY_NAME));
    appItemInfo.installTime = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.INSTALL_TIME));
    appItemInfo.typeId = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.TYPE_ID));
    appItemInfo.area = GridLayoutItemBuilder.getArea(resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.AREA)));
    appItemInfo.page = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.PAGE));
    appItemInfo.column = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.COLUMN));
    appItemInfo.row = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.ROW));
    appItemInfo.downloadProgress = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.DOWNLOAD_PROGRESS));
    appItemInfo.appStatus = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_STATUS));
    appItemInfo.iconResource = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ICON_RESOURCE));
    appItemInfo.callerName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.CALLER_NAME));
    appItemInfo.appIndex = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_INDEX));
    appItemInfo.intent = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.INTENT));
    return appItemInfo;
  }

  public setFormConfigAbility(formConfigAbility: string | undefined): GridLayoutItemBuilder {
    this.formConfigAbility = formConfigAbility;
    return this;
  }

  public setAppName(name: string | undefined): GridLayoutItemBuilder {
    this.appName = name;
    return this;
  }

  public setCardName(name: string | undefined): GridLayoutItemBuilder {
    this.cardName = name;
    return this;
  }

  public setCardId(cardId: string): GridLayoutItemBuilder {
    this.cardId = cardId;
    return this;
  }

  public setFolderId(folderId: string | undefined): GridLayoutItemBuilder {
    this.folderId = folderId;
    return this;
  }

  public setFormStackId(formStackId: string | undefined): GridLayoutItemBuilder {
    this.formStackId = formStackId;
    return this;
  }

  public setContainer(container: number | undefined): GridLayoutItemBuilder {
    this.container = container;
    return this;
  }

  public setFolderName(folderName: string | undefined): GridLayoutItemBuilder {
    this.folderName = folderName;
    return this;
  }

  public setBadgeNumber(badgeNumber: number): GridLayoutItemBuilder {
    this.badgeNumber = badgeNumber;
    return this;
  }

  public setTypeId(typeId: number | undefined): GridLayoutItemBuilder {
    this.typeId = typeId;
    return this;
  }

  public setArea(area: string): GridLayoutItemBuilder {
    let areaArray: number[] = [];
    let temp = area.split(',');
    if (!CheckEmptyUtils.isEmptyArr(temp) && temp.length === 2) {
      areaArray[0] = Number(temp[0]);
      areaArray[1] = Number(temp[1]);
    }
    this.area = areaArray;
    return this;
  }

  static getArea(area: string): number[] {
    let areaArray: number[] = [];
    let temp = area.split(',');
    if (!CheckEmptyUtils.isEmptyArr(temp) && temp.length === 2) {
      areaArray[0] = Number(temp[0]);
      areaArray[1] = Number(temp[1]);
    }
    return areaArray;
  }

  public setAreaType(areaType: number): GridLayoutItemBuilder {
    this.areaType = areaType;
    return this;
  }

  public setPage(page: number | undefined): GridLayoutItemBuilder {
    this.page = page;
    return this;
  }

  public setColumn(column: number | undefined): GridLayoutItemBuilder {
    this.column = column;
    return this;
  }

  public setRow(row: number | undefined): GridLayoutItemBuilder {
    this.row = row;
    return this;
  }

  public setPortraitPageIndex(pageIndex: number | undefined): GridLayoutItemBuilder {
    this.portraitPageIndex = pageIndex;
    return this;
  }

  public setPortraitColumn(column: number | undefined): GridLayoutItemBuilder {
    this.portraitColumn = column;
    return this;
  }

  public setPortraitRow(row: number | undefined): GridLayoutItemBuilder {
    this.portraitRow = row;
    return this;
  }

  public setPortraitArea(width: number | undefined, height: number | undefined): GridLayoutItemBuilder {
    if (width === undefined || height === undefined) {
      return this;
    }
    this.portraitArea = [width, height];
    return this;
  }

  public setLandscapePageIndex(pageIndex: number | undefined): GridLayoutItemBuilder {
    this.landscapePageIndex = pageIndex;
    return this;
  }

  public setLandscapeColumn(column: number | undefined): GridLayoutItemBuilder {
    this.landscapeColumn = column;
    return this;
  }

  public setLandscapeRow(row: number | undefined): GridLayoutItemBuilder {
    this.landscapeRow = row;
    return this;
  }

  public setLandscapeArea(width: number | undefined, height: number | undefined): GridLayoutItemBuilder {
    if (width === undefined || height === undefined) {
      return this;
    }
    this.landscapeArea = [width, height];
    return this;
  }

  public setBundleName(bundleName: string | undefined): GridLayoutItemBuilder {
    this.bundleName = bundleName;
    return this;
  }

  public setKeyName(keyName: string | undefined): GridLayoutItemBuilder {
    this.keyName = keyName;
    return this;
  }

  public setAbilityName(abilityName: string | undefined): GridLayoutItemBuilder {
    this.abilityName = abilityName;
    return this;
  }

  public setModuleName(moduleName: string | undefined): GridLayoutItemBuilder {
    this.moduleName = moduleName;
    return this;
  }

  public setAppIconId(appIconId: number): GridLayoutItemBuilder {
    this.appIconId = appIconId;
    return this;
  }

  public setAppLabelId(appLabelId: number): GridLayoutItemBuilder {
    this.appLabelId = appLabelId;
    return this;
  }

  setLayoutInfo(appItemInfos: AppItemInfo[]): GridLayoutItemBuilder {
    this.layoutInfo = appItemInfos;
    return this;
  }

  setFileFolderName(fileFolderName: string | undefined): GridLayoutItemBuilder {
    this.fileFolderName = fileFolderName;
    return this;
  }

  setUri(uri: string | undefined): GridLayoutItemBuilder {
    this.uri = uri;
    return this;
  }

  setIno(ino: string): GridLayoutItemBuilder {
    this.ino = ino;
    return this;
  }

  setFileType(fileType: number): GridLayoutItemBuilder {
    this.fileType = fileType;
    return this;
  }

  public setExtend1(extend1: string | undefined): GridLayoutItemBuilder {
    this.extend1 = extend1;
    return this;
  }

  public setExtend2(extend2: string | undefined): GridLayoutItemBuilder {
    this.extend2 = extend2;
    return this;
  }

  public setExtend3(extend3: number): GridLayoutItemBuilder {
    this.extend3 = extend3;
    return this;
  }

  public setIconResource(resource: string | undefined): GridLayoutItemBuilder {
    this.iconResource = resource;
    return this;
  }

  public setKindId(kindId: number | undefined): GridLayoutItemBuilder {
    this.kindId = kindId;
    return this;
  }

  public setDownloadProgress(progress: number | undefined): GridLayoutItemBuilder {
    this.downloadProgress = progress;
    return this;
  }

  public setAppStatus(status: number): GridLayoutItemBuilder {
    this.appStatus = status;
    return this;
  }

  public setCallerName(callerName: string | undefined): GridLayoutItemBuilder {
    this.callerName = callerName;
    return this;
  }

  public setInfoId(infoId: string | undefined): GridLayoutItemBuilder {
    this.infoId = infoId;
    return this;
  }

  public setIsTransparent(isTransparent: boolean): GridLayoutItemBuilder {
    this.isTransparent = isTransparent;
    return this;
  }

  public setAppIndex(appIndex: number): GridLayoutItemBuilder {
    this.appIndex = appIndex;
    return this;
  }

  public setShortcutId(shortcutId: string | undefined): GridLayoutItemBuilder {
    this.shortcutId = shortcutId;
    return this;
  }

  public setIntent(intent: string | undefined): GridLayoutItemBuilder {
    this.intent = intent;
    return this;
  }

  public setSize(size: number): GridLayoutItemBuilder {
    this.size = size;
    return this;
  }

  public setCtime(ctime: number): GridLayoutItemBuilder {
    this.ctime = ctime;
    return this;
  }

  public setMtime(mtime: number): GridLayoutItemBuilder {
    this.mtime = mtime;
    return this;
  }

  public setGameCardInfo(gameCardInfo: GameCardInfo): GridLayoutItemBuilder {
    this.gameCardInfo = gameCardInfo;
    return this;
  }

  public setTargetFormData(targetFormData: string | undefined): GridLayoutItemBuilder {
    this.targetFormData = targetFormData;
    return this;
  }

  public setScreenId(screenId: number | undefined): GridLayoutItemBuilder {
    this.screenId = screenId;
    return this;
  }

  buildGridLayoutItem(): GridLayoutItemInfo {
    let info = new GridLayoutItemInfo();
    info.setInfo(this);
    return info;
  }
}