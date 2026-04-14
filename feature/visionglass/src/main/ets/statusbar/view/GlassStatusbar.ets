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

import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { GlassSceneManager } from '../../scene/common/GlassSceneManager';
import { GlassStatusbarManager } from '../manager/GlassStatusbarManager';
import BatteryIcon from './BatteryIcon';
import BluetoothIcon from './BluetoothIcon';
import SignalIcon from './SignalIcon';
import TimeIcon from './TimeIcon';
import WlanIcon from './WlanIcon';
import { curves } from '@kit.ArkUI';
import MessageCenterIcon from './MessageCenterIcon';
import { PhoneCapsuleIcon } from './PhoneCapsuleIcon';
import { GlassStatusManager } from '../../common/manager/GlassStatusManager';
import CapsuleButton from '../models/CapsuleButton';
import { GlassStatusBarStyle } from './GlassStatusBarStyle';
import { GlassLayoutColor } from '../../common/constants/GlassLayoutConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlassButton } from '../component/GlassButton';
import { SCBSceneSession } from '@ohos/windowscene/src/main/ets/TsIndex';
import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';
import { GlassLayoutManager } from '../../common/manager/GlassLayoutManager';
import GlassPhoneCapsule from '../models/PhoneCapsule';
import { GlassStatusbarHoverManager } from '../manager/GlassStatusbarHoverManager';

const TAG: string = 'GlassStatusBar';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

/**
 * 状态栏
 */
@Component
export default struct GlassStatusBar {
  @Provide contentColor: string = GlassLayoutColor.STATUSBAR_COMPONENT_COLOR;
  @Provide statusBarType: StatusBarType = StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;
  @State isCallingAppActive: boolean = false;
  @State isCalling: boolean = GlassPhoneCapsule.getInstance().isAccept;
  private onCallingStatusChange = (isCalling: boolean) => {
    this.isCalling = isCalling;
  }
  /**
   * 实况显隐动画
   */
  private effect: TransitionEffect =
    TransitionEffect.OPACITY
      .animation({
        curve: curves.springMotion(0.6, 0.8)
      })
      .combine(TransitionEffect.scale({
        x: 0.3,
        y: 0
      }))
  /**
   * 应用前后台检测
   */
  private activeAppSceneListener = (set: Set<SCBSceneSession>): void => {
    this.isCallingAppActive = false;
    set.forEach((session: SCBSceneSession) => {
      if (session.sceneInfo.bundleName === GlassPhoneCapsule.getInstance().phoneInfo.bundleName) {
        this.isCallingAppActive = true;
      }
    })
    log.showInfo(`activeAppSceneListener,isCallingAppActive ${this.isCallingAppActive},isCalling ${this.isCalling}`);
  };

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    GlassPhoneCapsule.getInstance().registerCallingStatusChangeCallback(this.onCallingStatusChange);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    GlassPhoneCapsule.destroy();
    GlassStatusbarHoverManager.destroyInstance();
  }

  /**
   * 消息中心入口
   */
  @Builder
  message() {
    MessageCenterIcon();
  }

  /**
   * 通话实况
   */
  @Builder
  callStateLives() {
    PhoneCapsuleIcon();
  }

  /**
   * 控制中心入口
   */
  @Builder
  control() {
    Row({ space: GlassStatusBarStyle.STATUSBAR_COMPONENT_INTERVAL }) {
      TimeIcon();
      BluetoothIcon();
      WlanIcon();
      SignalIcon();
      BatteryIcon();
    }
    .height(GlassStatusBarStyle.ICON_SIZE)
    .margin({
      right: GlassStatusBarStyle.MARGIN_LEFT_RIGHT,
      left: GlassStatusBarStyle.MARGIN_LEFT_RIGHT
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Row({ space: GlassStatusBarStyle.STATUSBAR_COMPONENT_INTERVAL }) {
        GlassButton({ content: this.message, })
          .onClick(() => {
            log.showInfo(`onclick open notification center window`);
            GlassSystemSceneManager.getInstance().showSystemView(GlassSystemSceneType.GLASS_NOTIFICATION_CENTER);
          })
        if (this.isCalling && !this.isCallingAppActive) {
          CapsuleButton({
            content: (): void => {
              this.callStateLives();
            },
            color: GlassStatusBarStyle.CALL_CAPSULE_BACKGROUND_COLOR,
          })
            .transition(this.effect)
            .onClick(() => {
              let phoneSceneInfo = GlassPhoneCapsule.getInstance().phoneSceneInfo;
              if (phoneSceneInfo === undefined) {
                log.showWarn(`click CapsuleButton phoneSceneInfo is invalid`);
                return;
              }
              this.isCallingAppActive = true;
              GlassSceneManager.getInstance().startSceneFromOther(phoneSceneInfo);
            })
        }
        GlassButton({ content: this.control, })
          .onClick(() => {
            log.showInfo(`onclick open control window`);
            GlassSystemSceneManager.getInstance().showSystemView(GlassSystemSceneType.GLASS_CONTROL);
          })
      }
      .onHover((isHover: boolean) => {
        GlassStatusbarManager.getInstance().onHover(isHover);
      })
      .onAreaChange((oldValue, newValue) => {
        GlassStatusbarManager.getInstance().updatePosition(newValue);
      })
      .onAppear(() => {
        log.showInfo(`onAppear`);
        GlassStatusbarManager.getInstance().init();
        GlassStatusManager.getInstance().activeAppScene?.subscribe(this.activeAppSceneListener);
      })
      .onDisAppear(() => {
        log.showInfo(`onDisAppear`);
        GlassStatusbarManager.destroyInstance();
        GlassStatusManager.getInstance().activeAppScene?.unsubscribe(this.activeAppSceneListener);
      })
    }
    .size({
      width: GlassLayoutManager.getInstance().getScreenWidthPx() + 'px',
      height: GlassLayoutManager.getInstance().getScreenHeightPx() + 'px'
    })
  }
}