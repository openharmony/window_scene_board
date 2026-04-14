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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NotificationUtil } from '../../utils/NotificationUtil';
import { ILiveStarterVm, LiveStartWantAgentParams, StartResult } from '../interface/ILiveStarterVm';
import { LiveButtonModel } from '../model/LiveCommonModel';
import { LiveNotification } from '../model/LiveNotification';
import { LiveBaseVm } from './LiveBaseVm';
import { notificationManager } from '@kit.NotificationKit';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';
import { StartAppOneMirrorAnimation } from '../../animation/StartAppOneMirrorAnimation';
import { LiveStyle } from '../constants/LiveStyle';
import { ILiveCardListItemVm } from '../interface/ILiveCardListItemVm';
import { AnimationBase } from '../../animation/AnimationBase';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import {
  ClickNotificationErrorCode,
  ClickNotificationMaintenance } from '../../maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../maintenance/StatisticsConstants';
import { WantAgentUtil } from '../../utils/WantAgentUtil';
import { ArkUIAdapter, ViewName } from '../../utils/ArkUIAdapter';
import { BannerVm } from '../../vm/BannerVm';
import { sharedData } from '../../model/SendableData';
import type { NotificationWantAgentInfo } from '../../model/NotificationAppInfo';
import { LiveApsUtils } from '../../utils/LiveApsUtils';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import { EnvVm } from '../../vm/EnvVm';
import { ScreenLockAdapter } from '../../adapter/ScreenLockAdapter';

const TAG = 'LiveStarterVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const CHECK_PANEL_DELAY = 150;

export class LiveStarterVm extends LiveBaseVm implements ILiveStarterVm {
  protected startCardAnimation = new AnimationBase(AnimationBase.NAMES.NTF_OVERLAY_ANIMATION);

  /**
   * start service的场景延迟时间后检查面板是否成功关闭
   */
  protected handleStartService = async (agentInfo: NotificationWantAgentInfo): Promise<void> => {
    if (WantAgentUtil.isStartService(agentInfo.operationType)) {
      await SystemUICommonUtil.sleep(CHECK_PANEL_DELAY);
      if (BannerVm.instance.isLivePanel() && !this.vmInjector.getSwitchVm().isCollapsing && !sharedData.isExecuting) {
        this.vmInjector.getSwitchVm().collapseCardToCapsule();
      }
    }
  }

  public async startCardWantAgent(params: LiveStartWantAgentParams): Promise<StartResult> {
    log.showInfo(`Start card wantAgent for ${params.cardVm.live.hashCode}`);
    const clickInfo = ClickNotificationMaintenance.getInfo();
    try {
      if (EnvVm.instance.isScreenLock) {
        log.showInfo('Device is locked, wait unlock');
        const unlocked = await ScreenLockAdapter.unLock();
        if (!unlocked) {
          log.showInfo('Device unlocked failed or canceled');
          return { start: false };
        }
        log.showInfo('Device is unlocked');
      }
      if (params.cardVm.live.isCollaNotification) {
        const operInfo = params.operationInfo;
        const clickInfo = ClickNotificationMaintenance.getInfo();

        try {
          log.info(`start CollaNotification WantAgent for ${params.cardVm.live.hashCode}`);
          await NotificationUtil.distributeOperation(params.cardVm.live.hashCode,
            operInfo?.operationType ?? LiveStyle.DISTRIBUTE_OPERATION_CARD_JUMP,
            operInfo?.buttonIndex, operInfo?.actionName);
          ClickNotificationMaintenance.reportClick(undefined, clickInfo);
          log.showInfo(`CollaNotification: ${params.cardVm.live.hashCode} start WantAgent success.`);
          this.vmInjector.getCardListVm().resetOpacity();
          return { start: true }
        } catch (e) {
          log.showError(`start CollaNotification WantAgent for ${params.cardVm.live.hashCode} failed:`, e);
          ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL, clickInfo, e);
          return { start: false }
        }
      }

      if (!params.wantAgent) {
        log.showError(`Invalid wantAgent for ${params.cardVm.live.hashCode}`);
        ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.INVALID_WANTAGENT, clickInfo);
        return { start: false };
      }
      const agentInfo = params.wantAgentInfo ?? await WantAgentUtil.parseWantAgentInfo(params.wantAgent);
      this.vmInjector.getCapsuleListVm().isToEnterAppByClickCard = true;
      this.vmInjector.getCapsuleListVm().enterApplicationName = agentInfo?.bundleName;
      const launcherBundleName = WantAgentUtil.getLauncherBundleName(params.cardVm.live, agentInfo);
      params.wantAgentInfo = agentInfo;
      log.showInfo(`launch bundle: ${launcherBundleName}, operationType: ${agentInfo?.operationType}`);
      if (agentInfo && WantAgentUtil.isStartApp(agentInfo) && this.isStartAppByOneMirror()) {
        const cardRect = this.getCardRect(params);
        const promise = StartAppOneMirrorAnimation.instance.prepare({
          scene: this.vmInjector.scene,
          cardRect: cardRect,
          cardRadius: LiveStyle.CAPSULE_RADIUS,
          bundleName: launcherBundleName,
          onExecute: () => this.onExecute(params, cardRect),
        });
        const result = await Promise.all([
          promise,
          WantAgentUtil.startWantAgent(params.wantAgent),
          this.handleStartService(agentInfo),
        ]);
        if (result[0]) {
          this.vmInjector.getCardListVm().resetOpacity();
        }
        ClickNotificationMaintenance.reportClickWithResult(result[1], ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL,
          clickInfo);

        return { start: result[0], operationType: agentInfo.operationType };
      } else {
        const isSuccess = await WantAgentUtil.startWantAgent(params.wantAgent);
        ClickNotificationMaintenance.reportClickWithResult(isSuccess, ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL,
          clickInfo);
      }
    } catch (e) {
      log.error(`Start card wantAgent for ${params.cardVm.live.hashCode} error:`, e);
      ClickNotificationMaintenance.reportClickWithResult(false, ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL,
        clickInfo);
    } finally {
      this.vmInjector.getCapsuleListVm().isToEnterAppByClickCard = false;
      this.vmInjector.getCapsuleListVm().enterApplicationName = undefined;
    }
    return { start: false };
  }

  public async startCapsuleWantAgent(live: LiveNotification, needAnim?: boolean): Promise<void> {
    log.showWarn(`Start capsule wantAgent for ${live.hashCode}`);
    if (EnvVm.instance.isScreenLock) {
      log.showInfo('Device is locked, wait unlock');
      const unlocked = await ScreenLockAdapter.unLock();
      if (!unlocked) {
        log.showInfo('Device unlocked failed or canceled');
        return;
      }
      log.showInfo('Device is unlocked');
    }
    const agentInfo = live.wantAgentInfo ?? await WantAgentUtil.parseWantAgentInfo(live.wantAgent);
    this.vmInjector.getCapsuleListVm().isToEnterAppByClickCapsule = !live.capsule?.sticky;
    this.vmInjector.getCapsuleListVm().enterApplicationName = agentInfo?.bundleName;
    if (agentInfo && WantAgentUtil.isStartApp(agentInfo) && needAnim) {
      if (live.isInstant()) {
        const capsuleVm = this.vmInjector.getCapsuleVm(live);
        capsuleVm.isToDelete = true;
      }
    }
    WantAgentUtil.startWantAgent(live.wantAgent).then((isSuccess) => {
      ClickNotificationMaintenance.reportClickWithResult(isSuccess, ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL,
        { data: live, clickRegion: ClickRegion.CAPSULE_TRIGGER });
    }).finally(() => {
      setTimeout(() => {
        this.vmInjector.getCapsuleListVm().isToEnterAppByClickCapsule = false;
        this.vmInjector.getCapsuleListVm().enterApplicationName = undefined;
      }, 200);
    });
  }

  protected async onExecute(params: LiveStartWantAgentParams, cardRect: RectResult): Promise<void> {
    const cardVm = params.cardVm;
    const cardListVm = this.vmInjector.getCardListVm();
    log.showInfo(`On execute start app animation for ${cardVm.live.hashCode} begin`);
    params.onStartApp?.();

    // 动效开始前设置参数
    this.startCardAnimation.setInitialState(() => {
      for (const live of cardListVm.liveList) {
        if (cardVm.live !== live) {
          const otherCardVm = this.vmInjector.getCardListItemVm(live);
          otherCardVm.containerOpacity = 0;
        }
      }
      cardVm.contentSize = { width: cardRect.width, height: cardRect.height };
      cardVm.contentAlign = Alignment.Center;
    });

    // 执行动画
    LiveApsUtils.setLiveApsScene(StyleConstants.DEFAULT_1);
    await this.startCardAnimation.executeAnimation([
      {
        curve: StartAppOneMirrorAnimation.instance.curve,
        duration: 400,
        event: () => {
          cardVm.containerOpacity = 0;
        }
      },
      {
        delay: 400,
        duration: 1,
        event: () => {
          // 动效完成后还原参数
          cardVm.containerSize = { width: '100%', height: 'auto' };
          cardVm.containerOffsetY = 0;
          cardVm.contentAlign = Alignment.End;
          cardVm.contentSize = undefined;
        }
      }
    ], cardVm.live.hashCode);
    LiveApsUtils.setLiveApsScene(StyleConstants.DEFAULT_0);
    log.showInfo(`Execute start app animation for ${cardVm.live.hashCode} complete`);
  }

  public async triggerButton(live: LiveNotification, button: LiveButtonModel): Promise<void> {
    const clickInfo = ClickNotificationMaintenance.getInfo();
    try {
      log.showWarn(`Trigger button for ${live.hashCode}, buttonName: ${button.name}`);
      const bundle: notificationManager.BundleOption = live.agentBundle ?? {
        bundle: live.creatorBundleName,
        uid: live.creatorUid,
      };
      await notificationManager.triggerSystemLiveView(bundle, live.id, {
        buttonName: button.name,
      });
      ClickNotificationMaintenance.reportClick(undefined, clickInfo);
    } catch (e) {
      log.error('triggerButton fail:', e);
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.CLICK_LIVE_BUTTON_FAIL, clickInfo, e);
    }
  }

  /**
   * 按场景区分是否使用一镜到底动效
   */
  protected isStartAppByOneMirror(): boolean {
    return true;
  }

  protected getCardRect(params: LiveStartWantAgentParams): RectResult {
    return SystemUICommonUtil.getRect(params.cardVm.componentId,
      ArkUIAdapter.getUiContextByViewName(ViewName.BANNER_VIEW));
  }
}