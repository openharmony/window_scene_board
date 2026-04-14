/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { sSettingsUtil, GlobalContext } from '@ohos/frameworkwrapper';
import { CardSourceType, CommonConstants, Extend1Data, lockLayoutManager, PageInfoManager } from '@ohos/launchercommon';
import type { DesktopInformation, OuterDesktopInformation } from '@ohos/frameworkwrapper';
import { AppListInfo } from '@ohos/launchercommon';
import { GridLayoutUtil } from '@ohos/launchercommon';
import { GridLayoutItemInfo, ResidentLayoutCacheMgr, DockItemInfo, BaseLayoutCacheManager } from '@ohos/launchercommon';
import { DefaultDesktopLayoutInfo } from '@ohos/launchercommon';
import { PreferenceStore } from '@ohos/pagedesktop/src/main/ets/default/common/dao/PreferenceStore';
import { QueryAutoAlignStatus, Response } from '@ohos/pagedesktop/src/main/ets/default/service/impl/QueryAutoAlignStatus';

const TAG = 'DesktopInformationReporter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 *
 * 桌面概要信息的获取
 *
 * @since 2023-12-23
 */
export class DesktopInformationReporter {
  private static instance: DesktopInformationReporter;
  private appListInfo: AppListInfo = new AppListInfo();
  private outerAppListInfo: AppListInfo = new AppListInfo();
  private dockListInfo: DockItemInfo[] = [];
  
  // 堆叠卡片的数量
  private formStackNumber: number = 0;

  // 外屏堆叠卡片的数量
  private outerFormStackNumber: number = 0;

  // 文件夹数量
  private folderNumber: number = 0;

  // 小文件夹数量
  private smallFolderNumber: number = 0;

  // 大文件夹数量
  private bigFolderNumber: number = 0;

  // 桌面卡片的数量，包含普通卡片
  private faNumber: number = 0;

  // 新形态小外屏桌面卡片的数量
  private outerFaNumber: number = 0;

  // 新形态小外屏桌面应用图标的数量
  private outerIconNumber: number = 0;

  // 桌面堆叠卡片内的卡片数量
  private faOfFormStackNumber: number = 0;

  // 桌面预置堆叠卡片数量
  private presetsFormStackNumber: number = 0;

  // 外屏桌面预置堆叠卡片数量
  private outerPresetsFormStackNumber: number = 0;

  // 桌面预置卡片数量
  private presetsCardNumber: number = 0;

  // 外屏桌面预置卡片数量
  private outerPresetsCardNumber: number = 0;

  // 桌面升级卡片数量
  private upgradeCardNumber: number = 0;

  // 外屏快捷方式总数
  private outerShortcutIconNumber: number = 0;

  // 裸放桌面应用图标数量（未放置文件夹中）
  private bareIconNumber: number = 0;

  // 文件夹中应用图标数量
  private iconInFolder: number = 0;

  // 裸放桌面快捷方式数量（未放置文件夹中）
  private bareShortcutIconNumber: number = 0;

  // 文件夹中快捷方式数量
  private shortcutIconInFolder: number = 0;

  private constructor() {
  }

  private init(): void {
    this.clear();
    this.initInnerDesktopInformation();
  }

  private initInnerDesktopInformation(): void {
    this.appListInfo = AppStorage.get<AppListInfo>('appListInfo') as AppListInfo;
    let isOuter: boolean = false;
    this.appListInfo.appGridInfo.forEach((appItemInfo) => {
      if (!CheckEmptyUtils.isEmpty(appItemInfo)) {
        appItemInfo.forEach((appItemInfo) => {
          this.processAppItemInfoList(appItemInfo, isOuter);
        });
      }
    });
    this.dockListInfo = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    if (!CheckEmptyUtils.isEmpty(this.dockListInfo)) {
      this.dockListInfo.forEach((appItemInfo) => {
        this.processAppItemInfoList(appItemInfo, isOuter);
      });
    }
  }

  private initOuterDesktopInformation(): void {
    this.outerAppListInfo = AppStorage.get<AppListInfo>('outerAppListInfo') as AppListInfo;
    let isOuter: boolean = true;
    this.outerAppListInfo.appGridInfo.forEach((appItemInfo) => {
      if (!CheckEmptyUtils.isEmpty(appItemInfo)) {
        appItemInfo.forEach((appItemInfo) => {
          this.processAppItemInfoList(appItemInfo, isOuter);
        });
      }
    });
  }

  private processAppItemInfoList(appItemInfo: GridLayoutItemInfo | DockItemInfo, isOuter?: boolean): void {
    if (appItemInfo instanceof DockItemInfo) {
      switch (appItemInfo.itemType) {
        case CommonConstants.TYPE_FOLDER:
          this.handleFolder(appItemInfo, isOuter);
          break;
        case CommonConstants.TYPE_APP:
          this.handleApp(isOuter);
          break;
        case CommonConstants.TYPE_SHORTCUT_ICON:
          this.handleShortcutIcon(isOuter);
          break;
      }
    } else {
      switch (appItemInfo.typeId) {
        case CommonConstants.TYPE_FORM_STACK:
          this.handleFormStack(appItemInfo, isOuter);
          break;
        case CommonConstants.TYPE_FOLDER:
          this.handleFolder(appItemInfo, isOuter);
          break;
        case CommonConstants.TYPE_CARD:
          this.handleCard(isOuter);
          break;
        case CommonConstants.TYPE_APP:
          this.handleApp(isOuter);
          break;
        case CommonConstants.TYPE_SHORTCUT_ICON:
          this.handleShortcutIcon(isOuter);
          break;
      }
    }
  }

  private handleFormStack(appItemInfo: GridLayoutItemInfo, isOuter?: boolean): void {
    if (isOuter) {
      this.outerFormStackNumber++;
    } else {
      this.formStackNumber++;
    }
    this.statisticFormStack(appItemInfo, isOuter);
  }

  // 文件夹内
  private handleFolder(appItemInfo: GridLayoutItemInfo | DockItemInfo, isOuter?: boolean): void {
    if (isOuter) {
      this.handleOuterFolder(appItemInfo);
    } else {
      this.handleInnerFolder(appItemInfo);
    }
  }

  private handleOuterFolder(appItemInfo: GridLayoutItemInfo | DockItemInfo): void {
    appItemInfo.layoutInfo?.forEach((appItems: GridLayoutItemInfo[]) => {
      appItems.forEach((item: GridLayoutItemInfo) => {
        if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
          this.outerShortcutIconNumber++;
        }
      });
    });
  }

  private handleInnerFolder(appItemInfo: GridLayoutItemInfo | DockItemInfo): void {
    this.folderNumber++;
    if (GridLayoutUtil.isSmallFolder(appItemInfo)) {
      this.smallFolderNumber++;
    } else {
      this.bigFolderNumber++;
    }
    this.countAppIconInFolder(appItemInfo);
  }

  private handleCard(isOuter?: boolean): void {
    if (isOuter) {
      this.outerFaNumber++;
    } else {
      this.faNumber++;
    }
  }

  private handleApp(isOuter?: boolean): void {
    if (isOuter) {
      this.outerIconNumber++;
    } else {
      this.bareIconNumber++;
    }
  }

  private handleShortcutIcon(isOuter?: boolean): void {
    if (isOuter) {
      this.outerShortcutIconNumber++;
    } else {
      this.bareShortcutIconNumber++;
    }
  }

  private countAppIconInFolder(appItemInfo: GridLayoutItemInfo | DockItemInfo): void {
    let items: GridLayoutItemInfo[] = appItemInfo.layoutInfo?.flat() ?? [];
    items.forEach((item) => {
      if (item.typeId === CommonConstants.TYPE_APP) {
        this.iconInFolder++;
      } else if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        this.shortcutIconInFolder++;
      } else {
      }
    });
  }

  private statisticFormStack(appItemInfo: GridLayoutItemInfo, isOuter?: boolean): void {
    let countCardInFormStack: number = 0;
    let presetsNum: number = 0;
    let upgradeNum: number = 0;
    let items: GridLayoutItemInfo[][] | undefined = appItemInfo.layoutInfo;
    items?.forEach((innerItems) => {
      innerItems.forEach((item) => {
        countCardInFormStack++;
        const sourceType: string = Extend1Data.getCardSourceType(item.extend1);
        if (sourceType === CardSourceType.UPGRADE_MIGRATE) {
          upgradeNum++;
        } else if (sourceType === CardSourceType.SYS_PRESETS) {
          presetsNum++;
        } else {
        }
      });
    });
    const stackSourceType: string = Extend1Data.getCardSourceType(appItemInfo.extend1);
    if (isOuter) {
      if (stackSourceType === CardSourceType.SYS_PRESETS) {
        this.outerPresetsFormStackNumber++;
      }
      this.outerPresetsCardNumber += presetsNum;
      log.showInfo('statisticOuterFormStack stackId: %{public}d, outerFormStackNumber: %{public}d, ' +
        'outerPresetsFormStackNumber: %{public}d, outerPresetsCardNumber: %{public}d',
        appItemInfo.formStackId, this.outerFormStackNumber, this.outerPresetsFormStackNumber,
        this.outerPresetsCardNumber);
    } else {
      if (stackSourceType === CardSourceType.SYS_PRESETS) {
        this.presetsFormStackNumber++;
      }
      this.faOfFormStackNumber += countCardInFormStack;
      this.presetsCardNumber += presetsNum;
      this.upgradeCardNumber += upgradeNum;
      log.showInfo('statisticFormStack stackId: %{public}d, presetsFormStackNumber: %{public}d, ' +
        'presetsCardNumber: %{public}d, upgradeCardNumber: %{public}d',
        appItemInfo.formStackId, this.presetsFormStackNumber, this.presetsCardNumber, this.upgradeCardNumber);
    }
  }

  public async getDesktopInformation(): Promise<DesktopInformation> {
    let autoAlignStatus: boolean = await this.getAutoAlignStatus();
    let desktopInformation: DesktopInformation = {
      PNAMEID: '',
      PVERSIONID: '',
      SCREEN: this.getScreen(),
      ICON: this.getIcon(),
      BIGFOLDER: this.getBigFolder(),
      SMALLFOLDER: this.getSmallFolder(),
      FAOFFORMSTACK: this.getFaOfFormStack(),
      HOME_PAGE_INDEX: PageInfoManager.getInstance().getHomePageIndex(),
      FA: this.getFa(),
      FORMSTACK: this.getFormStack(),
      FOLDER: this.getFolder(),
      PRESETS_STACK_NUM: this.presetsFormStackNumber,
      PRESETS_CARD_NUM: this.presetsCardNumber,
      UPGRADE_CARD_NUM: this.upgradeCardNumber,
      ICONSIZE: Number(sSettingsUtil.getSecureValue('desktopIconChangeSize')),
      IS_NAME_SHOW: sSettingsUtil.getSecureValue('isDesktopIconShowName') !== 'false',
      FLOATING_BALL_SWITCH_STATUS: '0',
      LOCKLAYOUTSTATUS: lockLayoutManager.isLockLayout(),
      SHORTCUTICONNUMBER: this.getShortcutIcon(),
      BAREICONNUMBER: this.getBareIcon(),
      BARESHORTCUTICONNUMBER: this.getBareShortcutIcon(),
      DESKTOPLAYOUT: this.getDesktopLayout(),
      AUTOALIGNSTATUS: autoAlignStatus,
    };
    return desktopInformation;
  }

  /**
   * 返回外屏桌面信息
   *
   * @returns 外屏桌面图标和卡片数量
   */
  public getOuterDesktopInformation(): OuterDesktopInformation {
    let outerDesktopInformation: OuterDesktopInformation = {
      PNAMEID: '',
      PVERSIONID: '',
      ICON: this.outerIconNumber,
      FA: this.outerFaNumber,
      SCREEN: this.getOuterScreen(),
      FORMSTACK: this.getOuterFormStack(),
      PRESETS_CARD_NUM: this.outerPresetsCardNumber,
      PRESETS_STACK_NUM: this.outerPresetsFormStackNumber,
      SHORTCUT_NUM: this.outerShortcutIconNumber,
    };
    return outerDesktopInformation;
  }

  private getScreen(): number {
    return this.appListInfo.appGridInfo.length;
  }

  private getOuterScreen(): number {
    return this.outerAppListInfo.appGridInfo.length;
  }

  /**
   *
   * @returns 桌面图标的数量，包括文件夹内部的图标
   */
  private getIcon(): number {
    return this.bareIconNumber + this.iconInFolder;
  }

  /**
   *
   * @returns 桌面大文件夹的数量
   */
  private getBigFolder(): number {
    return this.bigFolderNumber;
  }

  /**
   *
   * @returns 桌面小文件夹的数量
   */
  private getSmallFolder(): number {
    return this.smallFolderNumber;
  }

  /**
   *
   * @returns 桌面所有堆叠卡片内的卡片的数量
   */
  private getFaOfFormStack(): number {
    return this.faOfFormStackNumber;
  }

  /**
   *
   * @returns 桌面所有堆叠卡片的数量
   */
  private getFormStack(): number {
    return this.formStackNumber;
  }

  private getOuterFormStack(): number {
    return this.outerFormStackNumber;
  }

  /**
   *
   * @returns 桌面所有卡片的数量，普通卡片，堆叠卡片的堆数
   */
  private getFa(): number {
    return this.faNumber + this.formStackNumber;
  }

  /**
   *
   * @returns 桌面所有文件夹的数量
   */
  private getFolder(): number {
    return this.folderNumber;
  }

  /**
   *
   * @returns 桌面应用快捷方式的数量，包括文件夹内部的应用快捷方式
   */
  private getShortcutIcon(): number {
    return this.bareShortcutIconNumber + this.shortcutIconInFolder;
  }

  /**
   *
   * @returns 裸放桌面应用的数量
   */
  private getBareIcon(): number {
    return this.bareIconNumber;
  }

  /**
   *
   * @returns 裸放桌面应用快捷方式的数量
   */
  private getBareShortcutIcon(): number {
    return this.bareShortcutIconNumber;
  }

  /**
   *
   * @returns 桌面布局信息（axb），a为列数，b为行数
   */
  private getDesktopLayout(): string {
    let desktopLayoutInfo: DefaultDesktopLayoutInfo =
      BaseLayoutCacheManager.getInstance().getDesktopLayoutInfo('desktopInformation');
    return `${desktopLayoutInfo.layoutDescription.column}x${desktopLayoutInfo.layoutDescription.row}`;
  }

  /**
   *
   * @returns 自动对齐开关状态
   */
  private async getAutoAlignStatus(): Promise<boolean> {
    let queryAutoAlignStatus: QueryAutoAlignStatus = new QueryAutoAlignStatus();
    let autoAlignStatus: string = await queryAutoAlignStatus.execute() as string;
    return autoAlignStatus === Response.openAutoAlign;
  }

  /**
   * get DesktopInformationUtil instance
   *
   * @return DesktopInformationUtil instance
   */
  static getInstance(): DesktopInformationReporter {
    if (DesktopInformationReporter.instance == null) {
      DesktopInformationReporter.instance = new DesktopInformationReporter();
    }
    log.showInfo(`DesktopInformation getInstance()`);
    DesktopInformationReporter.instance.init();
    return DesktopInformationReporter.instance;
  }

  private clear(): void {
    this.formStackNumber = 0;
    this.folderNumber = 0;
    this.smallFolderNumber = 0;
    this.bigFolderNumber = 0;
    this.faNumber = 0;
    this.outerFaNumber = 0;
    this.outerIconNumber = 0;
    this.faOfFormStackNumber = 0;
    this.presetsFormStackNumber = 0;
    this.presetsCardNumber = 0;
    this.upgradeCardNumber = 0;
    this.outerFormStackNumber = 0;
    this.outerPresetsFormStackNumber = 0;
    this.outerPresetsCardNumber = 0;
    this.outerShortcutIconNumber = 0;
    this.bareIconNumber = 0;
    this.iconInFolder = 0;
    this.bareShortcutIconNumber = 0;
    this.shortcutIconInFolder = 0;
  }
}