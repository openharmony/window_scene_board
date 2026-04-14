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

import { BusinessError } from '@kit.BasicServicesKit';
import wantAgent, { WantAgent } from '@ohos.app.ability.wantAgent';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { GlassSceneManager, Rect } from '../../scene/common/GlassSceneManager';
import { GlassStatusManager } from '../../common/manager/GlassStatusManager';
import { GlassAppWhiteListManager } from './../../common/manager/GlassAppWhiteListManager';
import { GlassShowToastOptions, GlassToastManager } from '../../toast/manager/GlassToastManager';
import GlassNtfConstant from '../common/GlassNtfConstant';
import { GlassBannerPanelManager } from '../manager/GlassBanerPanelManager';
import { GlassNtfManager, NtfChangeCallBack } from '../manager/GlassNtfManager';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NotificationUtil, OTHER_APP_TRANSPORT } from '../../notificationcenter/vm/NotificationGlassVm';
import NotificationConstant from '../../notificationcenter/common/NotificationConstant';
import { NtfToastCommon } from '../../common/constants/GlassLayoutConstants';
import { GlassSystemSceneType, GlassSystemSceneManager } from '../../scene/common/GlassSystemSceneManager';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassBannerContentVM');

export class BannerPanelContentVM {
  private static instance?: BannerPanelContentVM;
  private callBack?: BannerHeadsUpContentCallBack;
  private hideWindowWithAnimateCallBack?: () => void;
  private watchers: number = 0;
  private timeOut: boolean = false;
  private timerId?: number;
  private ntfChangeCallBack: NtfChangeCallBack = {
    addNtf: (ntfList: NotificationEntry[]) => {
      log.showInfo('addNtf notification');
      if (GlassSystemSceneManager.getInstance().isSystemViewShow(GlassSystemSceneType.GLASS_NOTIFICATION_CENTER)) {
        log.showInfo(`Notification center is show,add cancel`);
        return;
      }
      let ntf = ntfList[0];
      if (!ntf.isHeadsUp()) {
        log.showInfo(`Current notification is not headsup hashcode is ${ntf.hashCode}`);
        return;
      }
      if (NotificationUtil.checkIsInvalidCallNtf(ntf)) { //电话应用内，非来电类型通话横幅不显示
        this.removeNtf(ntfList);
        return;
      }
      const oldNtf = this.callBack?.getNtf();
      if (oldNtf) {
        log.showInfo('have oldNtf');
        if (NotificationUtil.checkIsCallNtf(oldNtf)) { //当前存在通话横幅消息未销毁
          if (!NotificationUtil.checkIsCallNtf(ntf)) { //新到横幅消息不是通话类型则返回，新到消息是通话类型则替代老消息
            return;
          }
        }
        this.hideWindowWithAnimate(() => {
          this.callBack?.notifyNtfChange(null);
          setTimeout(() => {
            this.setAutoCancelTimer(ntf);
            this.showWindow(ntf);
          }, GlassNtfConstant.STATUS_APPEAR_TIME);
        });
      } else {
        this.setAutoCancelTimer(ntf);
        this.showWindow(ntf);
      }
    },
    updateNtf: (ntfList: NotificationEntry[]) => {
      if (GlassSystemSceneManager.getInstance().isSystemViewShow(GlassSystemSceneType.GLASS_NOTIFICATION_CENTER)) {
        log.showInfo(`Notification center is show,add cancel`);
        return;
      }
      let ntf = ntfList[0];
      if (!ntf.isHeadsUp()) {
        log.showInfo(`Current notification is not headsup`);
        return;
      }
      log.showInfo('updateNtf notification');
      if (NotificationUtil.checkIsInvalidCallNtf(ntf)) {
        this.removeNtf(ntfList);
        return;
      }
      this.setAutoCancelTimer(ntf);
      this.callBack?.notifyNtfChange(ntf);
    },
    removeNtf: (ntfList: NotificationEntry[]) => {
      this.removeNtf(ntfList);
    }
  };

  private removeNtf(ntfList: NotificationEntry[]): void {
    log.showInfo('removeNtf');
    const oldNtf = this.callBack?.getNtf();
    if (oldNtf && oldNtf.id === ntfList[0].id) {
      this.hideWindowWithAnimate(() => {
        this.callBack?.notifyNtfChange(null);
      });
    }
  }

  private destroy(): void {
    this.removeAutoCancelTimer();
  }

  private constructor() {
  }

  public static getInstance(): BannerPanelContentVM {
    if (!BannerPanelContentVM.instance) {
      BannerPanelContentVM.instance = new BannerPanelContentVM();
    }
    return BannerPanelContentVM.instance;
  }

  public static destroyInstance(): void {
    BannerPanelContentVM.instance?.destroy();
    BannerPanelContentVM.instance = undefined;
  }

  public init(callBack: BannerHeadsUpContentCallBack): void {
    this.callBack = callBack;
    GlassNtfManager.getInstance().registerNtfChangeCallBack(this.ntfChangeCallBack);
  }

  public cancelNtf(ntf: NotificationEntry | null, animate: boolean = false): void {
    log.showInfo(`cancelNtf`);
    if (!ntf) {
      return;
    }
    if (animate) {
      this.hideWindowWithAnimate(() => {
        GlassNtfManager.getInstance().cancelNtf(ntf);
        this.callBack?.notifyNtfChange(null);
      })
      return;
    }
    this.hideWindow();
  }

  private hideWindow(): void {
    log.showInfo('hideWindow');
    GlassBannerPanelManager.getInstance().setNtfWindowVisibility(false);
    setTimeout(() => {
      GlassStatusManager.getInstance().activeSystemScene?.dispatch((map) => {
        map.set(GlassSystemSceneType.GLASS_BANNER, false);
        return map;
      });
    }, GlassNtfConstant.STATUS_APPEAR_TIME);
  }

  private hideWindowWithAnimate(callBack?: () => void): void {
    log.showInfo('hideWindowWithAnimate');
    this.hideWindowWithAnimateCallBack = callBack;
    animateTo({
      duration: GlassNtfConstant.BANNER_ANIMATE_DURATION,
      onFinish: () => {
        this.onFinishCallback();
      }
    }, () => {
      GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_BANNER);
    })
    setTimeout(() => {
      GlassStatusManager.getInstance().activeSystemScene?.dispatch((map) => {
        map.set(GlassSystemSceneType.GLASS_BANNER, false);
        return map;
      });
    }, GlassNtfConstant.STATUS_APPEAR_TIME);
  }

  private onFinishCallback = () => {
    log.showInfo('hideWindowWithAnimate onFinish');
    GlassBannerPanelManager.getInstance().setNtfWindowVisibility(false);
    this.hideWindowWithAnimateCallBack?.();
  }

  private showWindow(ntf: NotificationEntry): void {
    log.showInfo('showWindow');
    this.callBack?.notifyNtfChange(ntf);
    GlassStatusManager.getInstance().activeSystemScene?.dispatch((map) => {
      map.set(GlassSystemSceneType.GLASS_BANNER, true);
      return map;
    });
    this.startShowWindow();
  }

  private startShowWindow(): void {
    log.showInfo('startShowWindow');
    GlassBannerPanelManager.getInstance().setNtfWindowVisibility(true);
  }

  /**
   * 判断通知是否是实况通知
   */
  public isLiveNtf(ntf: NotificationEntry | null): boolean {
    if (ntf && ntf.isLiveType()) {
      return true;
    }
    return false;
  }

  /**
   * 设置通知自动隐藏定时器
   */
  private setAutoCancelTimer(ntf: NotificationEntry | null): void {
    log.showInfo('setAutoCancelTimer');
    this.timeOut = false;
    this.removeAutoCancelTimer();
    if (!this.callBack) {
      return;
    }
    if (this.isLiveNtf(ntf) && ntf?.creatorBundleName === GlassNtfConstant.PHONE_BUNDLE_NAME) {
      return;
    }
    if (!ntf) {
      return;
    }
    this.timerId = setTimeout(() => {
      this.removeAutoCancelTimer();
      this.timeOut = true;
      if (this.watchers > 0) {
        return;
      }
      this.cancelNtf(ntf, true);
    }, GlassNtfConstant.CANCEL_DEFAULT_TIME + GlassNtfConstant.APPEAR_TIME);
  }

  /**
   * 取消通知自动隐藏定时器
   */
  private removeAutoCancelTimer(): void {
    if (!this.timerId) {
      return;
    }
    clearTimeout(this.timerId);
    this.timerId = undefined;
  }

  /**
   * 检测是否需要隐藏窗口
   */
  private checkShouldHideWindow(): boolean {
    if (this.watchers > 0) {
      log.showInfo('watchers not null');
      return false;
    }
    if (!this.checkNtfTimeout()) {
      log.showInfo('ntf not timeout');
      return false;
    }
    return true;
  }

  /**
   * 检查当前通知是否过期
   */
  public checkNtfTimeout(): boolean {
    return this.timeOut;
  }

  public addWatcher(): void {
    this.watchers++;
  }

  public resetWatcher(): void {
    this.watchers = 0;
  }

  public removeWatcher(): void {
    log.showInfo('removeWatcher')
    if (this.watchers > 0) {
      this.watchers--;
      if (this.checkShouldHideWindow()) {
        this.hideWindowWithAnimate(() => {
          this.callBack?.notifyNtfChange(null);
        });
      }
    }
  }

  public clickNtf(): void {
    log.showInfo('clickNtf');
    if (!this.callBack) {
      return;
    }
    const ntf = this.callBack.getNtf();
    if (!ntf) {
      return;
    }
    let checkBundleName: string = ntf.creatorBundleName === NotificationConstant.PHONE_BUNDLE_NAME ?
    NotificationConstant.CONTACT_BUNDLE_NAME : ntf.creatorBundleName;
    let appWant: Want | undefined = GlassAppWhiteListManager.getInstance().getWhiteListAppWant(checkBundleName);
    if (!appWant) {
      let options: GlassShowToastOptions = {
        message: NtfToastCommon.CAN_NOT_OPEN_MSG,
        bottom: NtfToastCommon.TOAST_BOTTOM,
        duration: NtfToastCommon.TOAST_DURATION,
        width: NtfToastCommon.CAN_NOT_OPEN_MSG_WID
      }
      GlassToastManager.getInstance().showToast(options);
      return;
    }
    if (ntf.creatorBundleName === GlassSceneManager.getInstance().getActiveWant()?.bundleName) {
      this.hideWindowWithAnimate(() => {
        this.callBack?.notifyNtfChange(null);
      });
      return;
    }
    const agent: WantAgent = ntf.wantAgent;
    let triggerInfo: wantAgent.TriggerInfo = {
      code: 0,
      startOptions: { displayId: GlassSceneManager.getInstance().getScreenId() }
    };
    let triggerCallback = (err?: BusinessError) => {
      if (err) {
        log.error(`getUid failed! ${err.code} ${err.message}`);
      }
    }
    try {
      wantAgent.getWant(agent).then((data) => {
        if (data.bundleName === OTHER_APP_TRANSPORT) {
          GlassSceneManager.getInstance().startSceneFromIcon({
            bundleName: appWant?.bundleName,
            abilityName: appWant?.abilityName,
            moduleName: appWant?.moduleName
          });
        } else {
          try {
            wantAgent.trigger(agent, triggerInfo, triggerCallback);
          } catch (err) {
            log.error(`getUid failed! ${err.code} ${err.message}`);
          }
          return
        }
      }).catch((err: BusinessError) => {
        log.error(`getWant failed, code: ${JSON.stringify(err.code)}, message: ${JSON.stringify(err.message)}`);
      });
    } catch (err) {
      log.error(`getWant failed! ${err.code} ${err.message}`);
    }
    this.hideWindowWithAnimate(() => {
      this.callBack?.notifyNtfChange(null);
    });
  }
}

export interface BannerHeadsUpContentCallBack {
  /**
   * 获取当前页面正在显示的通知数据
   *
   * @return 通知数据
   */
  getNtf(): NotificationEntry | null;

  /**
   * 告诉页面通知数据变更
   *
   * @param ntf 通知数据
   */
  notifyNtfChange(ntf: NotificationEntry | null): void;
}