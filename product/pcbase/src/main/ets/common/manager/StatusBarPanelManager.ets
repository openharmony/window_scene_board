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
import { ConfigurationConstant } from '@kit.AbilityKit';

import {
  LogDomain,
  LogHelper,
  ObjUtil,
} from '@ohos/basicutils';
import {
  ConfigurationEvent,
  EventManager,
  EvtBus,
  ResourceManager,
  WallpaperChangeEvent,
} from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { CommonConstants } from '@ohos/launchercommon';
import { ColorModeViewData } from '@ohos/systemuicommon/Index';
import StatusBarPanelStyleManager from './StatusBarPanelStyleManager';

const TAG = 'StatusBarPanelManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);


export class StatusBarPanelManager {
  private eventMgr: EventManager = EvtBus.createEventManager();
  /**
   * 缓存二级面板信息
   */
  private panelInfoCache: PanelInfoCache = {};
  private statusBarPanelInfos: StatusBarPanelInfoList = new StatusBarPanelInfoList();
  private statusBarPSM: StatusBarPanelStyleManager = new StatusBarPanelStyleManager();
  private static mInstance: StatusBarPanelManager;

  private constructor() {
  }

  init(): void {
    this.eventMgr
      .on(WallpaperChangeEvent, this.handleWallpaperChangeEvent)
      .on(ConfigurationEvent, this.handleConfigurationEvent);
  }

  static getInstance(): StatusBarPanelManager {
    if (StatusBarPanelManager.mInstance == null) {
      StatusBarPanelManager.mInstance = new StatusBarPanelManager();
    }
    return StatusBarPanelManager.mInstance;
  }

  /**
   * 壁纸颜色变更回调
   */
  private handleWallpaperChangeEvent = (event: WallpaperChangeEvent) => {
    if (!event) {
      log.showInfo('WallpaperChangeEvent undefined or null');
      return;
    }
    log.showInfo('handleWallpaperChangeEvent backgroundColor: ' + event.avgColor);
    this.panelInfoCache.avgColor = event.avgColor;
    this.onAvgColorChange(event.avgColor);
  }
  /**
   * 属性变更回调
   */
  private handleConfigurationEvent = (event: ConfigurationEvent) => {
    if (!event) {
      log.showInfo('ConfigurationEvent undefined or null');
      return;
    };
    log.showInfo('colorMode ' + event.config?.colorMode);
    if (!(event.config?.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)) {
      this.panelInfoCache.darkMode = event?.config?.colorMode;
      let isDark = (this.panelInfoCache.darkMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) ?? false;
      log.showInfo('handleConfigurationEvent isDark: ' + isDark);
      this.onDarkModeChange(isDark);
    };
  }

  /**
   * 窗口平均色回调
   *
   * @param avgColor 平均色
   */
  private onAvgColorChange(avgColor?: string): void {
    if (!avgColor) {
      log.showInfo('onAvgColorChange avgColor undefined');
      return;
    }
    this.statusBarPanelInfos.forEach((panelInfo: StatusBarPanelInfo) => {
      if (avgColor !== panelInfo.panelAvgColor) {
        panelInfo.panelAvgColor = avgColor;
      }
    });
  }

  /**
   * 深色模式状态栏二级面板回调
   *
   * @param isDark 是否是深色模式
   */
  private onDarkModeChange(isDark: boolean): void {
    this.statusBarPanelInfos.forEach((panelInfo: StatusBarPanelInfo) => {
      if (isDark !== panelInfo.isDark) {
        this.updateStatusBarPanelInfo(isDark, panelInfo);
      }
    });
  }

  /**
   * 更新二级面板窗口样式
   * @param isDark 是否是深色模式
   */
  private updateStatusBarPanelInfo(isDark: boolean, panelInfo: StatusBarPanelInfo): void {
    if (!panelInfo) {
      log.showError('updateStatusBarPanelInfo panelInfo error');
      return;
    }
    panelInfo.isDark = isDark;
    panelInfo.panelBlurBgColor = this.statusBarPSM.getBgBlurColor(isDark);
    panelInfo.panelInsideBorderColor = this.statusBarPSM.getInsideBorderColor();
    panelInfo.panelOutsideBorderColor = this.statusBarPSM.getOutSideBorderColor(isDark);
    panelInfo.panelBorderWidth = this.statusBarPSM.getBorderWidth();
    if (!panelInfo.panelShadowOptions) {
      panelInfo.panelShadowOptions = this.statusBarPSM.getDefaultShadowM(isDark);
    }
    panelInfo.panelRadius = px2vp(ResourceManager.getInstance()
      .getNumberByResource(this.statusBarPSM.getWindowRadius()));
    let sceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(panelInfo.getId());
    sceneSession?.setBorderRadius(panelInfo.panelRadius)
    sceneSession?.setShadowChange(
      panelInfo.panelShadowOptions?.radius as number,
      panelInfo.panelShadowOptions?.color as string,
      panelInfo.panelShadowOptions?.offsetX as number,
      panelInfo.panelShadowOptions?.offsetY as number
    )
    this.updateNormalPanelInfo(isDark, panelInfo);
  }

  /**
   * 更新二级面板通用样式
   * @param isDark 是否是深色模式
   * @param panelInfo 二级面板属性
   */
  private updateNormalPanelInfo(isDark: boolean, panelInfo: StatusBarPanelInfo): void {
    if (!panelInfo) {
      log.showError('updateNormalPanelInfo panelInfo error');
      return;
    }
    let normalPanelInfo = panelInfo as NormalPanelInfo;
    normalPanelInfo.titleTextColor = this.statusBarPSM.getNormalTitleColor(isDark);
    normalPanelInfo.subTitleTextColor = this.statusBarPSM.getNormalSubTitleColor(isDark);
    normalPanelInfo.selectedListTextColor = this.statusBarPSM.getNormalSelectedListTextColor(isDark);
    normalPanelInfo.listTextColor = this.statusBarPSM.getNormalListTextColor(isDark);
    normalPanelInfo.listAssistedTextColor = this.statusBarPSM.getNormalListAssistedTextColor(isDark);
    normalPanelInfo.listLeftIconColor = this.statusBarPSM.getNormalLeftIconColor(isDark);
    normalPanelInfo.selectedListRightIconColor = this.statusBarPSM.getNormalRightIconColor(isDark);
    normalPanelInfo.footnoteTextColor = this.statusBarPSM.getNormalFootnoteTextColor(isDark);
    normalPanelInfo.separatorColor = this.statusBarPSM.getNormalSeparatorColor(isDark);
    normalPanelInfo.brightnessBaseColor = this.statusBarPSM.getBrightnessBaseColor(isDark);
    normalPanelInfo.titleTextSize = this.statusBarPSM.getNormalTitleSize();
    normalPanelInfo.subTitleTextSize = this.statusBarPSM.getNormalSubTitleSize();
    normalPanelInfo.listTextSize = this.statusBarPSM.getNormalListTextSize();
    normalPanelInfo.listAssistedTextSize = this.statusBarPSM.getNormalListAssistedTextSize();
    normalPanelInfo.footnoteTextSize = this.statusBarPSM.getNormalFootnoteTextSize();
    normalPanelInfo.hoverRadius = this.statusBarPSM.getNormalHoverRadius();
    normalPanelInfo.changeColorMode(isDark);
  }

  getStatusBarInfoById(persistentId: number): StatusBarPanelInfo | undefined {
    const index: number = this.statusBarPanelInfos.findIndex((findPanelInfo) => {
      return findPanelInfo.getId() === persistentId;
    });
    if (index === CommonConstants.INVALID_VALUE) {
      log.showError('getStatusBarInfoById: ' + undefined);
      return undefined;
    }
    return this.statusBarPanelInfos[index];
  }

  createPanelInfo(persistentId: number, panelShadowOptions?: ShadowOptions): StatusBarPanelInfo {
    const index: number = this.statusBarPanelInfos.findIndex((findPanelInfo) => {
      return findPanelInfo.getId() === persistentId;
    });
    if (index === CommonConstants.INVALID_VALUE) {
      let normalPanelInfo = this.createNormalPanelInfo(persistentId, panelShadowOptions);
      return normalPanelInfo;
    }
    return this.statusBarPanelInfos[index];
  }

  private createNormalPanelInfo(persistentId: number, panelShadowOptions?: ShadowOptions):
    StatusBarPanelInfo {
    let normalPanelInfo = new NormalPanelInfo(persistentId);
    normalPanelInfo.panelShadowOptions = panelShadowOptions;
    this.statusBarPanelInfos.push(normalPanelInfo);
    let isDark = (this.panelInfoCache.darkMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) ?? false;
    let avgColor = this.panelInfoCache.avgColor;
    // 同步二级面板属性
    this.onAvgColorChange(avgColor);
    this.onDarkModeChange(isDark);
    return normalPanelInfo;
  }

  deletePanelInfo(panelInfo?: StatusBarPanelInfo): void {
    if (ObjUtil.isInvalid(panelInfo)) {
      log.showError('unregisterPanelInfo panelInfo param error');
      return;
    }
    const index: number = this.statusBarPanelInfos.findIndex((findPanelInfo) => {
      return findPanelInfo.getId() === panelInfo?.getId();
    });
    if (index !== CommonConstants.INVALID_VALUE) {
      this.statusBarPanelInfos.splice(index, 1);
    }
  }

  destory(): void {
    this.statusBarPanelInfos = [];
    this.eventMgr.offAll();
  }
}

export interface PanelInfoCache {
  avgColor?: string;
  darkMode?: ConfigurationConstant.ColorMode;
}

@Observed
export class StatusBarPanelInfoList extends Array<StatusBarPanelInfo> {
}

@Observed
export class StatusBarPanelInfo {
  private persistentId: number = 0;
  public isDark?: boolean;
  public panelAvgColor?: string;
  public panelBlurBgColor?: Resource;
  public panelInsideBorderColor?: string;
  public panelOutsideBorderColor?: string;
  public panelBorderWidth?: Resource;
  public panelShadowOptions?: ShadowOptions;
  public panelRadius?: number;

  constructor(persistentId: number) {
    this.persistentId = persistentId;
  }

  getId(): number {
    return this.persistentId;
  }
}

@Observed
export class NormalPanelInfo extends StatusBarPanelInfo {
  public titleTextColor?: ResourceStr;
  public subTitleTextColor?: ResourceStr;
  public selectedListTextColor?: ResourceStr;
  public brightnessBaseColor?: ResourceStr;
  public brightnessViewData?: ColorModeViewData;
  public listTextColor?: ResourceStr;
  public listAssistedTextColor?: ResourceStr;
  public listLeftIconColor?: ResourceStr;
  public selectedListRightIconColor?: ResourceStr;
  public footnoteTextColor?: ResourceStr;
  public separatorColor?: ResourceStr;
  public titleTextSize?: Length;
  public subTitleTextSize?: Length;
  public listTextSize?: Length;
  public listAssistedTextSize?: Length;
  public footnoteTextSize?: Length;
  public hoverRadius?: ResourceStr;

  constructor(persistentId: number) {
    super(persistentId)
  }


  getBrightnessViewData(): ColorModeViewData | undefined {
    if (!this.brightnessViewData) {
      this.brightnessViewData = new ColorModeViewData();
    }
    return this.brightnessViewData;
  }

  changeColorMode(isDark: boolean): void {
    if (isDark) {
      this.brightnessViewData?.changeDarkMode();
    } else {
      this.brightnessViewData?.changeLightMode();
    }
  }
}