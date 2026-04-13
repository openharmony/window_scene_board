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
import { LogDomain, Logger, RectItem } from '@ohos/basicutils';
import { ArkUIAdapter, ViewName } from '../../utils/ArkUIAdapter';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { curves } from '@kit.ArkUI';
import { AnimationBase } from '../../animation/AnimationBase';
import { NotificationUtil } from '../../utils/NotificationUtil';
import bundleManager from '@ohos.bundle.bundleManager';
import { SCBSceneMode } from '@ohos/windowscene';
import { SceneSessionAdapter } from '../../adapter/SceneSessionAdapter';
import { ILiveCardFloatingVm, LiveCardFloatingWantAgentParams } from '../interface/ILiveCardFloatingVm';
import { LiveItemBaseVm } from './LiveBaseVm';
import { LiveNotification } from '../model/LiveNotification';
import { LiveVmInjector } from '../LiveVmInjector';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';
import { SystemUIUseScene } from '../../constants/SystemuiConstants';
import { EnvVm } from '../../vm/EnvVm';
import { WantAgentUtil } from '../../utils/WantAgentUtil';
import { FloatingDisplayMode } from '../../banner/common/BannerFloatingModel';
import { ASCFWindowMgrAdapter } from '../../adapter/ASCFWindowMgrAdapter';
import { NotificationWantAgentInfo } from '../../model/NotificationAppInfo';

const TAG = 'LiveCardFloatingVm';
const log = Logger.getLogHelper(LogDomain.SYS_UI);
const CLICK_TO_FLOATING_ANIMATION_MAX_WAIT_TIME = 100;
const WAIT_FOR_FLOATING_OPENED_TIMEOUT = 2000;

/**
 * 屏幕宽度分级
 */
enum ScreenWidth {
  LARGE = 375,
  MIDDLE = 360
}

/**
 * 不同屏幕宽度下的图标大小
 */
enum IconSize {
  LARGE = 58,
  MIDDLE = 54,
  SMALL = 52
}

/**
 * 卡片悬浮窗VM
 */
@ObservedV2
export class LiveCardFloatingVm extends LiveItemBaseVm implements ILiveCardFloatingVm {
  public scene: SystemUIUseScene;
  @Trace public isDeformFlag = false;
  @Trace public iconScale: number = 1;
  @Trace public cardDeformHeight: number = 0;
  @Trace public cardDeformWidth: number = 0;
  @Trace public maskOpacity: number = 0;
  @Trace public cardDeformOffsetX: number = 0;
  @Trace public cardDeformOffsetY: number = 0;

  private isStartingFloating = false;

  constructor(vmInjector: LiveVmInjector, live: LiveNotification) {
    super(vmInjector, live);
    this.scene = vmInjector.scene;
  }

  public async canOpenFloating(params: LiveCardFloatingWantAgentParams): Promise<boolean> {
    const agentInfo = params.wantAgentInfo ?? await WantAgentUtil.parseWantAgentInfo(params.wantAgent);
    params.wantAgentInfo = agentInfo;

    if (params.wantAgentInfo && !WantAgentUtil.isStartApp(params.wantAgentInfo)) {
      log.showWarn(TAG, `${this.live.key} is start app, no need floating`);
      return false;
    }
    if (!await this.isNeedFloating(agentInfo?.bundleName)) {
      log.showInfo(TAG, `${this.live.key} is not need floating`);
      return false;
    }
    if (await SceneSessionAdapter.getIsMidScene()) {
      log.showInfo(TAG, TAG, 'Current window mode is middle scene');
      return false;
    }
    if (!await this.isSupportFloating(agentInfo)) {
      log.showInfo(TAG, `${this.live.key} is not supportFloating`);
      return false;
    }
    if (await this.isExcludeForFloating()) {
      log.showInfo(TAG, `${this.live.key} is exclude for floating`);
      return false;
    }
    const callerBundle = this.live.creatorBundleName ?? '';
    const callerIndex = this.live.appIndex ?? 0;
    if (NotificationUtil.isTargetAppForeground(callerBundle, callerIndex, agentInfo?.want)) {
      log.showInfo(TAG, `Current app ${callerBundle}_${callerIndex} is foreground`);
      return false;
    }
    return true;
  }

  public async startFloatingForClick(params: LiveCardFloatingWantAgentParams): Promise<void> {
    log.showInfo(TAG, `startFloatingForClick: ${this.live.key}`);
    if (this.isStartingFloating) {
      log.showWarn(TAG, `Current is running: ${this.live.key}`);
      return;
    }
    this.isStartingFloating = true;
    try {
      if (params.cardId) {
        this.startFloatingWindow(FloatingDisplayMode.CLICK_WITHOUT_ANIMATION, params);
        const targetRect = await this.getFloatingRect();
        await this.animateToFloatingWindow(params.cardId, targetRect);
      } else {
        this.startFloatingWindow(FloatingDisplayMode.CLICK_WITH_ANIMATION, params);
      }
    } catch (e) {
      log.error(`startFloatingForClick for ${this.live.key} error:`, e);
    } finally {
      this.isStartingFloating = false;
    }
  }

  public async runCardHideAnimation(event: () => void): Promise<void> {
    const animation = new AnimationBase(AnimationBase.NAMES.FLOATING_LAYER_ANIMATION, true);
    await animation.executeAnimation([
      {
        curve: Curve.Linear,
        duration: 200,
        event,
      }
    ]);
  }

  protected async isNeedFloating(bundleName?: string): Promise<boolean> {
    if (EnvVm.instance.isImmersive) {
      log.showInfo(TAG, 'Current is in immersive');
      return true;
    }

    if (await ASCFWindowMgrAdapter.isWindowModeForMetaService(bundleName)) {
      log.showInfo(TAG, 'app need floating');
      return true;
    }

    return false;
  }

  private async isSupportFloating(wantAgentInfo?: NotificationWantAgentInfo): Promise<boolean> {
    const want = wantAgentInfo?.want;
    log.showInfo(TAG, `checkIsSupportFloating, want:${want?.bundleName}, ${want?.moduleName}, ${want?.abilityName}`);
    if (!this.live || !want) {
      return false;
    }

    const bundleName = want.bundleName ?? '';
    const abilityName = want.abilityName ?? '';
    const queryKey: string = bundleName + (want.moduleName ?? '') + abilityName;
    const supportModes =
      await SceneSessionAdapter.getAbilityWindowSupportInfo(queryKey, bundleName, abilityName);
    return supportModes?.indexOf(bundleManager.SupportWindowMode.FLOATING) > -1;
  }

  /**
   * 悬浮窗是否存在业务互斥，如果是则不支持悬浮窗
   * @returns
   */
  private async isExcludeForFloating(): Promise<boolean> {
    const isExclusive = await SceneSessionAdapter.checkIsExclusive(this.live.creatorBundleName, 'FLOATING', false);
    return isExclusive;
  }

  private async startFloatingWindow(displayMode: FloatingDisplayMode,
    params: LiveCardFloatingWantAgentParams): Promise<void> {
    log.showInfo(TAG, `StartFloatingWindow, displayMode: ${displayMode}`);

    if (!params.wantAgent) {
      log.showWarn(TAG, `No wantAgent for ${this.live.key}`);
      return;
    }

    const agentInfo = params.wantAgentInfo ?? await WantAgentUtil.parseWantAgentInfo(params.wantAgent);
    if (!agentInfo?.want) {
      log.showWarn(TAG, `No want for ${this.live.key}`);
      return;
    }
    await WantAgentUtil.startWantAgent(params.wantAgent, {
      code: 0,
      extraInfos: { floatingDisplayMode: displayMode },
      startOptions: { windowMode: SCBSceneMode.FLOATING },
    });
  }

  private getFloatingRect(): Promise<RectItem | undefined> {
    return new Promise<RectItem | undefined>((resolve) => {
      const callback = (rect: RectItem | undefined): void => {
        resolve(rect);
        clearTimeout(timerId);
        SceneSessionAdapter.unRegisterOnGetFloatingRectCallback({ callback }, `${TAG}_registerOnGetFloatingRectCallback`);
      };
      const timerId = setTimeout(() => {
        log.showInfo(TAG, `Get floating rect timeout: ${this.live.key}`);
        callback(undefined);
      }, CLICK_TO_FLOATING_ANIMATION_MAX_WAIT_TIME);
      SceneSessionAdapter.registerOnGetFloatingRectCallback({ callback }, `${TAG}_registerOnGetFloatingRectCallback`);
    });
  }

  private getTargetIconScale(): number {
    let screenWidth = ArkUIAdapter.px2vp(DeviceInfoVm.instance.width);
    let screenHeight = ArkUIAdapter.px2vp(DeviceInfoVm.instance.height);
    const width = Math.min(screenWidth, screenHeight);
    const iconSize = this.iconScale * 32;
    if (width >= ScreenWidth.LARGE) {
      return IconSize.LARGE / iconSize;
    } else if (width < ScreenWidth.MIDDLE) {
      return IconSize.SMALL / iconSize;
    } else {
      return IconSize.MIDDLE / iconSize;
    }
  }

  /**
   * 动画过渡到窗口
   */
  private async animateToFloatingWindow(cardId: string, targetRect?: RectItem): Promise<void> {
    const cardRect = SystemUICommonUtil.getRect(cardId, ArkUIAdapter.getUiContextByViewName(ViewName.BANNER_VIEW));
    log.info(`animateToFloatingWindow for ${cardId}, cardRect: `, cardRect, `targetRect:`, targetRect);
    const animation = new AnimationBase(AnimationBase.NAMES.FLOATING_LAYER_ANIMATION, true);
    animation.setInitialState(() => {
      this.iconScale = 1;
      this.maskOpacity = 0;
      this.cardDeformWidth = cardRect.width;
      this.cardDeformHeight = cardRect.height;
      this.cardDeformOffsetX = 0;
      this.cardDeformOffsetY = 0;
    });
    this.isDeformFlag = true;
    await animation.executeAnimation([{
      curve: curves.springMotion(0.5, 0.8),
      finishCallbackFast: true,
      event: () => {
        this.iconScale = this.getTargetIconScale();
        this.maskOpacity = 1;
        if (targetRect) {
          this.cardDeformWidth = ArkUIAdapter.px2vp(targetRect.width());
          this.cardDeformHeight = ArkUIAdapter.px2vp(targetRect.height());
          this.cardDeformOffsetX = ArkUIAdapter.px2vp(targetRect.left) - cardRect.x;
          this.cardDeformOffsetY = ArkUIAdapter.px2vp(targetRect.top) - cardRect.y;
        }
      },
      onFinish: () => {
        SceneSessionAdapter.notifyAnimationFinishedCallback(true);
      }
    }]);
    await animation.executeAnimation([{
      curve: curves.springMotion(0.4, 1.0),
      finishCallbackFast: true,
      event: () => {
        // 悬浮窗拉起后蒙版消失动效
        this.maskOpacity = 0;
        this.iconScale = 1.2 * this.iconScale;
      }
    }]);
    this.isDeformFlag = false;
  }

  private waitForFloatingWindowOpened(): Promise<void> {
    return new Promise<void>((resolve) => {
      const callback = (): void => {
        log.showInfo(TAG, `Wait for floating window of ${this.live.key} is opened`);
        clearTimeout(timerId);
        SceneSessionAdapter.unRegisterOnNtfFloatingWindowCallback({ callback }, `${TAG}_registerOnNtfFloatingWindowCallback`);
        resolve();
      };
      const timerId = setTimeout(() => {
        log.showWarn(TAG, `Wait for floating window of ${this.live.key} is timeout`);
        SceneSessionAdapter.unRegisterOnNtfFloatingWindowCallback({ callback }, `${TAG}_registerOnNtfFloatingWindowCallback`);
        resolve();
      }, WAIT_FOR_FLOATING_OPENED_TIMEOUT);
      SceneSessionAdapter.registerOnNtfFloatingWindowCallback({ callback }, `${TAG}_registerOnNtfFloatingWindowCallback`);
    });
  }
}
