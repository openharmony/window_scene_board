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
import { DragGridItem } from '@ohos/componentdrag';
import { AppItemInfo } from './AppItemInfo';
import { ExtraInfo } from './ExtraInfo';
import { GameCardInfo } from './GameCardInfo';
import GridLayoutItemBuilder from './GridLayoutItemBuilder';
import type { ShortcutInfo } from '../bean/ReceiveEventInfo';

/**
 * Item info of GridLayoutInfo item.
 */
export default class GridLayoutItemInfo extends ExtraInfo implements DragGridItem {
  /**
   * componentId
   */
  public componentId?: string;
  /**
   * GridLayoutItemInfo: id
   */
  public id?: number;

  /**
   * GridLayoutItemInfo: infoId
   */
  public infoId?: string;

  /**
   * GridLayoutItemInfo: infoName
   */
  public infoName?: string;

  /**
   * GridLayoutItemInfo: cardId
   */
  public cardId?: string;

  /**
   * GridLayoutItemInfo: ID of the bigfolder.
   */
  public folderId?: string;

  /**
   * GridLayoutItemInfo: ID of the formstack.
   */
  public formStackId?: string;

  /**
   * GridLayoutItemInfo: bigfolder id
   * Not in bigfolder: - 100
   * In a bigfolder: ID of the bigfolder.
   */
  public container?: number;

  /**
   * GridLayoutItemInfo: bigfolder Name
   */
  public folderName?: string;

  /**
   * GridLayoutItemInfo: badgeNumber
   */
  public badgeNumber?: number;

  /**
   * GridLayoutItemInfo: type  0:app  1:card  3:bigfolder
   */
  public typeId?: number;

  /**
   * GridLayoutItemInfo: appCatagory
   */
  public appCatagory?: number;

  /**
   * GridLayoutItemInfo: file/folder uri
   */
  public uri?: string;

  /**
   * GridLayoutItemInfo: file/folder name
   */
  public fileFolderName?: string;

  /**
   * GridLayoutItemInfo: file type. 0: folder, 1: file, etc.
   */
  public fileType?: number;

  /**
   * GridLayoutItemInfo: file/folder Unique Identifier
   */
  public ino?: string;

  /**
   * GridLayoutItemInfo: area
   */
  public area?: number[];

  /**
   * GridLayoutItemInfo: page
   */
  public page?: number;

  /**
   * GridLayoutItemInfo: column of positions
   */
  public column?: number;

  /**
   * GridLayoutItemInfo: row of positions
   */
  public row?: number;

  /**
   * Indicates bundleName.
   */
  public bundleName: string = '';

  /**
   * Indicates bundleName.
   */
  public oldBundleNames?: string[] = [];

  /**
   * Indicates keyName.
   */
  public keyName?: string;

  /**
   * Indicates abilityName.
   */
  public abilityName: string = '';

  /**
   * Indicates moduleName.
   */
  public moduleName?: string;

  /**
   * GridLayoutItemInfo[]: bigFolder apps info
   */
  public layoutInfo?: Array<GridLayoutItemInfo[]>;

  /**
   * Indicates appIconId.
   */
  public appIconId: number = 0;

  /**
   * Indicates appIconId.
   */
  public appLabelId?: number;

  /**
   * Indicates form refresh date.
   */
  public formRefreshDate?: string;

  /**
   * GridLayoutItemInfo: extend1
   */
  public extend1?: string;

  /**
   * GridLayoutItemInfo: extend2
   */
  public extend2?: string;

  /**
   * GridLayoutItemInfo: extend3
   */
  public extend3?: number;

  public negativeId: number = 0;

  public isSelect: boolean = false;

  /*
    差分操作类型
   */
  public operation?: string;

  /*
    应用插入目标文件夹ID
   */
  public targetFolderId?: string;

  /*
    应用插入文件夹部位
   */
  public addPosition?: string;

  /*
    被替换元素包名或文件夹ID
   */
  public replacement?: string;

  /*
    被替换元素类型
   */
  public replacementTypeId?: number;

  /*
    指定落位元素包名或文件夹ID
   */
  public settlement?: string;

  /*
    指定落位元素类型
   */
  public settlementTypeId?: number;

  /*
    指定插入部位
   */
  public settlementPosition?: string;

  /**
   * Is form transparent
   */
  public isTransparent?: boolean = false;

  public declare enterEditing: boolean;

  public downloadProgress: number = 0;

  public appStatus: number | undefined = 0;

  public iconResource: string | undefined;

  public callerName: string | undefined;

  /**
   * container backplane
   */
  public hasContainerBackplane?: boolean;

  /**
   * id of desktop shortcut
   */
  public shortcutId?: string = '';

  /**
   * 应用分身标识
   */
  public appIndex?: number = 0;

  /**
   * 特殊应用标识
   */
  public intent?: string = '';

  /**
   * 文件/文件夹大小
   */
  public size?: number = 0;

  /**
   * 创建时间
   */
  public ctime?: number = 0;

  /**
   * 修改时间
   */
  public mtime?: number = 0;

  public gameCardInfo?: GameCardInfo;

  /**
   * 是否支持应用多实例
   */
  public enableNewAppInstance?: boolean;

  /**
   * for lazy rotate
   */
  public landscapeRow?: number;

  /**
   * for lazy rotate
   */
  public landscapeColumn?: number;

  /**
   * for lazy rotate
   */
  public landscapePage?: number;

  /**
   * GridLayoutItemInfo: area in landscape
   */
  public landscapeArea?: number[];

  /**
   * for lazy rotate
   */
  public portraitRow?: number;

  /**
   * for lazy rotate
   */
  public portraitColumn?: number;

  /**
   * for lazy rotate
   */
  public portraitPage?: number;

  /**
   * GridLayoutItemInfo: area in portrait
   */
  public portraitArea?: number[];

  /**
   * 是否是备份恢复的
   */
  public isNeedRestoreFromBackup?: boolean;

  public isAppLocked?: boolean = false;

  /**
   * 孵化卡片信息
   */
  public targetFormData?: string = '';

  public isEmpty?: boolean = false;

  public screenId?: number = 0;

  shortcutInfo?: ShortcutInfo;

  constructor() {
    super();
  }

  public setInfo(gridLayoutItemBuilder: GridLayoutItemBuilder): void {
    this.id = gridLayoutItemBuilder.id;
    this.infoId = gridLayoutItemBuilder.infoId;
    this.cardId = gridLayoutItemBuilder.cardId;
    this.folderId = gridLayoutItemBuilder.folderId;
    this.formStackId = gridLayoutItemBuilder.formStackId;
    this.container = gridLayoutItemBuilder.container;
    this.folderName = gridLayoutItemBuilder.folderName;
    this.fileFolderName = gridLayoutItemBuilder.fileFolderName;
    this.ino = gridLayoutItemBuilder.ino;
    this.fileType = gridLayoutItemBuilder.fileType;
    this.uri = gridLayoutItemBuilder.uri;
    this.badgeNumber = gridLayoutItemBuilder.badgeNumber;
    this.typeId = gridLayoutItemBuilder.typeId;
    this.area = gridLayoutItemBuilder.area;
    this.areaType = gridLayoutItemBuilder.areaType;
    this.page = gridLayoutItemBuilder.page;
    this.column = gridLayoutItemBuilder.column;
    this.row = gridLayoutItemBuilder.row;
    this.portraitPage = gridLayoutItemBuilder.portraitPageIndex;
    this.portraitColumn = gridLayoutItemBuilder.portraitColumn;
    this.portraitRow = gridLayoutItemBuilder.portraitRow;
    this.portraitArea = gridLayoutItemBuilder.portraitArea;
    this.landscapePage = gridLayoutItemBuilder.landscapePageIndex;
    this.landscapeColumn = gridLayoutItemBuilder.landscapeColumn;
    this.landscapeRow = gridLayoutItemBuilder.landscapeRow;
    this.landscapeArea = gridLayoutItemBuilder.landscapeArea;
    this.kindId = gridLayoutItemBuilder.kindId;
    this.bundleName = gridLayoutItemBuilder.bundleName ?? '';
    this.abilityName = gridLayoutItemBuilder.abilityName ?? '';
    this.moduleName = gridLayoutItemBuilder.moduleName;
    this.keyName = gridLayoutItemBuilder.keyName;
    this.appIconId = gridLayoutItemBuilder.appIconId;
    this.extend1 = gridLayoutItemBuilder.extend1;
    this.extend2 = gridLayoutItemBuilder.extend2;
    this.extend3 = gridLayoutItemBuilder.extend3;
    this.appLabelId = gridLayoutItemBuilder.appLabelId;
    this.appName = gridLayoutItemBuilder.appName;
    this.cardName = gridLayoutItemBuilder.cardName;
    this.formConfigAbility = gridLayoutItemBuilder.formConfigAbility;
    this.downloadProgress = gridLayoutItemBuilder.downloadProgress ?? 0;
    this.appStatus = gridLayoutItemBuilder.appStatus;
    this.iconResource = gridLayoutItemBuilder.iconResource;
    this.callerName = gridLayoutItemBuilder.callerName;
    this.isTransparent = gridLayoutItemBuilder.isTransparent;
    this.shortcutId = gridLayoutItemBuilder.shortcutId;
    this.appIndex = gridLayoutItemBuilder.appIndex;
    this.intent = gridLayoutItemBuilder.intent;
    this.size = gridLayoutItemBuilder.size;
    this.ctime = gridLayoutItemBuilder.ctime;
    this.mtime = gridLayoutItemBuilder.mtime;
    this.targetFormData = gridLayoutItemBuilder.targetFormData;
    this.gameCardInfo = gridLayoutItemBuilder.gameCardInfo;
    this.screenId = gridLayoutItemBuilder.screenId;
  }

  public fillInfoWithAppItem(appItem : AppItemInfo) : GridLayoutItemInfo {
    this.appName = appItem.appName;
    this.appIconId = appItem.appIconId;
    this.appLabelId = appItem.appLabelId;
    this.bundleName = appItem.bundleName;
    this.abilityName = appItem.abilityName;
    this.moduleName = appItem.moduleName;
    this.typeId = appItem.typeId;
    this.area = appItem.area;
    this.page = appItem.page;
    this.column = appItem.column;
    this.kindId = appItem.kindId;

    this.bundleType = appItem.bundleType;
    this.applicationName = appItem.applicationName;
    this.downloadProgress = appItem.downloadProgress ?? 0;
    this.appStatus = appItem.appStatus;
    this.iconResource = appItem.iconResource;
    this.callerName = appItem.callerName;
    this.appIndex = appItem.appIndex;
    this.intent = appItem.intent;
    return this;
  }

  public toAppItemInfo(): AppItemInfo {
    const appItem = new AppItemInfo();
    appItem.appName = this.appName ?? '';
    appItem.appIconId = this.appIconId;
    appItem.appLabelId = this.appLabelId;
    appItem.bundleName = this.bundleName;
    appItem.abilityName = this.abilityName;
    appItem.moduleName = this.moduleName;
    appItem.typeId = this.typeId;
    appItem.area = this.area;
    appItem.page = this.page;
    appItem.column = this.column;
    appItem.row = this.row;
    appItem.kindId = this.kindId;
    appItem.shortcutId = this.shortcutId;

    appItem.bundleType = this.bundleType;
    appItem.applicationName = this.applicationName;
    appItem.downloadProgress = this.downloadProgress;
    appItem.appStatus = this.appStatus;
    appItem.iconResource = this.iconResource;
    appItem.callerName = this.callerName;
    appItem.appIndex = this.appIndex;
    appItem.intent = this.intent;
    return appItem;
  }

  /**
   * 从FolderData中迁移
   * @returns
   */
  public static getEmptyItem(): GridLayoutItemInfo {
    let emptyItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    emptyItem.bundleName = '';
    emptyItem.abilityName = '';
    emptyItem.folderId = '-1';
    emptyItem.appIconId = -1;
    emptyItem.negativeId = -1;
    emptyItem.isSelect = false;
    emptyItem.enterEditing = false;
    emptyItem.downloadProgress = 0;
    emptyItem.appStatus = 0;
    emptyItem.iconResource = undefined;
    emptyItem.callerName = undefined;
    emptyItem.isEmpty = true;
    return emptyItem;
  }
}
