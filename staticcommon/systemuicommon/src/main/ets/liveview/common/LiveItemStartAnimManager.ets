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

import { OverlayStartAnimHelper } from '../../overlay/OverlayStartAnimHelper';
import {
  CommonUtils,
  SingletonHelper,
  DomainName,
  LogDomain,
  LogHelper,
  TraceUtil,
  RectInfo
} from '@ohos/basicutils';
import { ApsUtils } from '@ohos/frameworkwrapper';
import {
  SCBTransitionManager,
  SCBTransitionController
} from '@ohos/windowscene';
import { LiveUseScene, LiveViewCommonConstants } from './LiveConstants';
import { DefaultPanelZIndex } from '../../base/common/info/DefaultPanelZIndex';
import { CardBorderRadius, OverlayAnimScene, OverlayCardInfo } from '../../overlay/OverlayCardInfo';
import { performanceMonitor } from '@kit.ArkUI';
import DropDownPanelManager from '../../manager/DropDownPanelManager';
// import apsManager from '@hms.graphic.apsManager';
import { APSSceneState } from '../../constants/SystemuiConstants';
import OverlayAnimGuarantee from '../../overlay/OverlayAnimGuarantee';
import { StartAbilityOverlayAnimate } from './StartAbilityOverlayAnimate';
import { OverlayAnimExecutors } from '../../overlay/OverlayAnimExecutor';
import { SystemUICcmConfig } from '../../utils/SystemUICcmConfig';
import lazy { StatusBarMoveDownVmV1 } from '../../statusbar/vm/StatusBarMoveDownVm';
import lazy { StatusBarMoveDownVmV2 } from '../../statusbar/vm/StatusBarMoveDownVm';

const TAG = 'LiveItemStartAnimManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 动效参数
 */
export class AnimParam {
  /**
   * 通知ID
   */
  public cardId? : string;

  /**
   * 卡片组件ID
   */
  public cardComponentId?: string;

  /**
   * 卡片组件ID
   */
  public cardRadius?: CardBorderRadius;

  /**
   * 卡片位置信息, 若指定则以该位置为准
   */
  public cardPosition?: RectInfo;

  /**
   * 启动的应用包名
   */
  public startBundleName?: string;

  /**
   * 卡片使用场景
   */
  public scene?: LiveUseScene;

  /**
   * 是否锁屏
   */
  public isLockScreen?: boolean = false;

  /**
   * 准备完成回调
   */
  public onPreComplete?: () => void;

  /**
   * 动效完成回调
   */
  public onAnimComplete?: () => void;

  /**
   * 是否需要收起面板
   */
  public isNeedCollapseDropdownPanel?: boolean;
}

/**
 * 实况卡片点击启动动效
 */
class LiveItemStartAnimManager {
  /**
   * 场景-面板层级映射
   */
  private scenePanelMap: Map<LiveUseScene | undefined, DefaultPanelZIndex> = new Map([
    [LiveUseScene.SCENE_NTF_CENTER, DefaultPanelZIndex.PANEL_DROPDOWN],
    [LiveUseScene.SCENE_HEADS_UP, DefaultPanelZIndex.PANEL_BANNER],
    [LiveUseScene.SCENE_LIVE_LIST, DefaultPanelZIndex.PANEL_BANNER]
  ]);
  /**
   * 动效超时重置任务
   */
  private resetAnimTimeout?: number;

  private startingByNtfItemClick: boolean = false;

  /**
   * 是否允许胶囊消失动效（点击实况通知卡片不出现胶囊消失动效，点击应用图标出现胶囊消失动效）
   */
  private isCapsuleHideAnimEnable = true;

  /* 当前controller */
  private currController?: SCBTransitionController;

  public isStartingByNtfItemClick(): boolean {
    return this.startingByNtfItemClick;
  }

  retIsCapsuleHideAnimEnable() {
    this.isCapsuleHideAnimEnable = true;
  }

  getIsCapsuleHideAnimEnable(): boolean {
    return this.isCapsuleHideAnimEnable;
  }

  /**
   * 启动动效前准备
   *
   * @param cardId 通知卡片ID
   * @param agent 启动agent
   * @param panelZIndex 面板层级
   */
  startAnimPre(param: AnimParam): void {
    this.isCapsuleHideAnimEnable = false;
    // 锁屏通知当前不支持启动动效
    if (param?.scene === LiveUseScene.SCENE_SCREEN_LOCK) {
      log.showInfo('StartAnimPre for %{public}s', LiveUseScene[LiveUseScene.SCENE_SCREEN_LOCK]);
      param?.onPreComplete?.();
      return;
    }
    if (!param.startBundleName) {
      log.showInfo('StartAnimPre for none startBundleName');
      param?.onPreComplete?.();
      this.afterStartAnim(param.isNeedCollapseDropdownPanel, false);
      return;
    }
    log.showInfo(`startAnimPre :${param?.startBundleName} :${param?.scene} :${param?.isLockScreen}`);
    try {
      this.startingByNtfItemClick = true;
      if (param?.scene === LiveUseScene.SCENE_SCREEN_LOCK_NOTIFICATION) {
        StartAbilityOverlayAnimate.getInstance().onOverlayAnimateStart();
        StartAbilityOverlayAnimate.getInstance().prepareForOverlayAnimate(param);
      } else {
        this.currController = OverlayStartAnimHelper.startAnimPre({
          cardBgId: this.getItemContentId(param),
          cardContentId: this.getItemContentId(param),
          cardPosition: param.cardPosition,
          startBundleName: param.startBundleName,
          oriPanelZIndex: this.scenePanelMap.get(param?.scene) ?? 0,
          cardBgColor: LiveViewCommonConstants.ITEM_BG_COLOR,
          cardBgBrightness: undefined,
          cardBgSaturate: undefined,
          cardBgBlurStyle: undefined,
          cardBgBackdropBlur: undefined,
          cardRadius: this.getItemRadius(param),
          animScene: param.scene === LiveUseScene.SCENE_NTF_CENTER ? OverlayAnimScene.TYPE_START_APP_FROM_NTF_CENTER :
            undefined,
          onAnimActive: (): void => this.onAnimActive(),
          onAnimCanceled: (): void => this.onAnimCanceled(),
          onAnimInactive: (): void => this.clearAnimInfo(),
        }, param.isLockScreen ? OverlayAnimScene.TYPE_START_APP_FROM_LOCK_SCREEN : undefined);
      }
      // 准备完成回调
      OverlayAnimExecutors.getLastOrCreateExecutor().addBeforeHandler(this.resetMoveDown);
      OverlayAnimGuarantee.start();
      param?.onPreComplete?.();

      // 超时重置任务，存在非启动页面场景
      this.clearResetTimeout();

      this.handleAnimExpCase();
    } catch (err) {
      log.showWarn('Catch an exception when call getBundleName 2. Execute onPreComplete.');
      param?.onPreComplete?.();
      this.afterStartAnim();
    }
  }

  /**
   * 控制下沉的状态栏回到默认位置
   */
  public resetMoveDown = () => {
    const isLiveV2 = SystemUICcmConfig.instance.isEnabledLive2;
    if (isLiveV2) {
      return StatusBarMoveDownVmV2.getInstance().resetMoveDown();
    } else {
      return StatusBarMoveDownVmV1.getInstance().resetMoveDown();
    }
  }
  /**
   * 处理动画异常场景未进入onAnimInactive 导致的清理动作没执行
   */
  private handleAnimExpCase(): void {
    this.resetAnimTimeout = setTimeout(() => {
      log.showWarn('HandleAnimExpCase. exec timeout %{public}s for %{public}s', this.startingByNtfItemClick,
        this.currController?.overlayCardInfo?.startBundleName);
      SCBTransitionManager.getInstance().resetSpecOverlayTransitionController(this.currController);
      this.currController = undefined;
      if (this.startingByNtfItemClick) {
        this.afterStartAnim();
      }
    }, OverlayCardInfo.sceneAnimParam.duration ?? 400 + 20); // 动画时延 400ms, 这里多一帧
  }

  /**
   * 获取卡片内容组件ID
   */
  private getItemContentId(param: AnimParam): string {
    return !param.cardComponentId || CommonUtils.isEmpty(param.cardComponentId) ?
       LiveViewCommonConstants.getItemContentId(param?.cardId, param?.scene) : param.cardComponentId;
  }

  /**
   * 获取卡片边角半径
   */
  private getItemRadius(param: AnimParam): CardBorderRadius {
    if (param.cardRadius === undefined || CommonUtils.isInvalid(param.cardRadius)) {
      return {
        topLeft: LiveViewCommonConstants.ITEM_BG_RADIUS,
        topRight: LiveViewCommonConstants.ITEM_BG_RADIUS,
        bottomLeft: LiveViewCommonConstants.ITEM_BG_RADIUS,
        bottomRight: LiveViewCommonConstants.ITEM_BG_RADIUS
      };
    }
    return param.cardRadius;
  }

  /**
   * 动效启动回调
   */
  private onAnimActive(): void {
    // 动效启动，清除超时任务
    this.clearResetTimeout();
    log.showInfo(`onAnimActive ${TraceUtil.CORE_METHOD_LIVE_WIN_TO_APP} start.`)
    TraceUtil.startTrace(DomainName.SYS_UI, TraceUtil.CORE_METHOD_LIVE_WIN_TO_APP);
  }

  private afterStartAnim(isCollapseDropdownPanel: boolean = true, isNeedEndReport: boolean = true): void {
    log.showInfo('After start anim. OnAnimInactive. isCollapseDropdownPanel: %{public}s', isCollapseDropdownPanel);
    this.clearAnimInfo(isNeedEndReport);
    if (isCollapseDropdownPanel) {
      OverlayAnimGuarantee.cancel('AfterStartAnim.');
      DropDownPanelManager.hideWindowDirectly();
    }
  }

  private onAnimCanceled(): void {
    log.showWarn('OnAniCanceled.');
    this.clearAnimInfo();
    OverlayStartAnimHelper.resetOverlayTransition('ResetOverlayTransitionOnAnimCanceled');
  }

  private clearAnimInfo(isNeedEndReport: boolean = true): void {
    this.clearResetTimeout();
    this.startingByNtfItemClick = false;
    // 横幅拉起应用场景控帧，具体帧率由HGM根据负载情况计算：end
    // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, APSSceneState.END_SCENE);
    if (isNeedEndReport) {
      performanceMonitor.end('LAUNCHER_APP_LAUNCH_FROM_NOTIFICATIONBAR');
    }
    performanceMonitor.end('LV_INTO_APP_ANIM');
    TraceUtil.endTrace(DomainName.SYS_UI, TraceUtil.CORE_METHOD_LIVE_WIN_TO_APP);
  }

  /**
   * 清除重置任务
   */
  private clearResetTimeout(): void {
    if (!CommonUtils.isInvalid(this.resetAnimTimeout)) {
      clearTimeout(this.resetAnimTimeout);
      this.resetAnimTimeout = undefined;
    }
  }
}

// 单例
export let liveStartAnimMgr = SingletonHelper.getInstance(LiveItemStartAnimManager, TAG);