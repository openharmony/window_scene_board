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

import common from '@ohos.app.ability.common';
import { sOutSideWindowMgr, } from '@ohos/frameworkwrapper';
import { SystemEvent } from '../utils/event/SystemEvent';
import { VoiceConstant } from '../constant/VoiceConstant';
import Want from '@ohos.app.ability.Want';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { JsonUtil } from '../utils/JsonUtil';
import sDropDownPanelManager from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import commonEventManager from '@ohos.commonEventManager';

const TAG: string = 'VoiceAgent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class VoiceService {

  private static sInstance?: VoiceService;

  private uiExtProxy?: UIExtensionProxy;

  private constructor() {
    this.init();
  }

  // 监听应用变更
  private bundleChangeEvent: SystemEvent = new SystemEvent();

  private init(): void {
    this.bundleChangeEvent.subscriber(commonEventManager.Support.COMMON_EVENT_PACKAGE_CHANGED,
      (commonEvent?: commonEventManager.CommonEventData) => {
        if (commonEvent?.bundleName === VoiceConstant.BUNDLE_NAME) {
          this.updateBundleChange?.();
        }
      });
  }

  // 监听应用市场变更
  public updateBundleChange = () => {};

  static getInstance(): VoiceService {
    if (VoiceService.sInstance === undefined) {
      VoiceService.sInstance = new VoiceService();
    }
    return VoiceService.sInstance;
  }

  public setUiProxy(uiExtProxy: UIExtensionProxy): void {
    this.uiExtProxy = uiExtProxy;
  }

  /**
   * 发送消息给语音助手 uiExtension
   * @param data key-value格式的报文
   */
  public sendMsgToUiExtension(data: ESObject): void {
    try {
      this.uiExtProxy?.send(data);
      const proxyIsLive:boolean = this.uiExtProxy ? true : false;
      log.showInfo(`sendMsgToUiExtension[${proxyIsLive}] ${JsonUtil.parseObjToStr(data)}`);
    } catch (e) {
      log.showError(`sendMsgToUiExtension err: ${JsonUtil.parseObjToStr(data)}`);
    }
  }

  // 拉起语音助手主对话
  public pullVoicePage(context: common.UIAbilityContext): void {
    log.showInfo(`pullVoicePage`);
    context.startAbility({
      bundleName: VoiceConstant.BUNDLE_NAME,
      abilityName: 'VoiceAbility',
    } as Want);
  }

  /**
   * 屏幕的内屏、外屏切换
   * @param isInnerToOuter true表示内屏切外屏, false表示外屏切外屏
   */
  public switchVerdeScreen(isInnerToOuter: boolean): void {
    if (isInnerToOuter) {
      this.sendMsgToUiExtension({
        action: 'screen_switch_state',
        value: 'inner_screen_to_outer_screen',
      });
    } else {
      this.sendMsgToUiExtension({
        action: 'screen_switch_state',
        value: 'outer_screen_to_inner_screen',
      });
    }
    AppStorage.setOrCreate<boolean>(VoiceConstant.isFoldStatus, isInnerToOuter);
  }

  // 拉起语音助手进程
  public pullVoicePageIfNeed(): void {
    const isShowLive: boolean = AppStorage.get<boolean>(VoiceConstant.isShowVoiceLive) ?? false;
    if (isShowLive) {
      log.showInfo(`pullVoicePage`);
      this.sendMsgToUiExtension({
        action: VoiceConstant.PULL_VOICE_PAGE,
      });
    }
  }

  // 拖拽开始时, 发送动效开始的消息
  public startDrag(): void {
    this.sendMsgToUiExtension({
      action: 'enter_state',
      value: 'on_drag_start'
    });
  }

  // 是否展示负一屏
  public updateNegativeScreenVisibility(isShow: boolean): void {
    if (isShow) {
      this.sendMsgToUiExtension({
        action: 'enter_state',
        value: 'full_screen_shown',
      });
    } else {
      // 判断状态中心是否在前台展示
      if (!sDropDownPanelManager.isPanelShowing()) {
        this.sendMsgToUiExtension({
          action: 'enter_state',
          value: 'full_screen_hidden',
        });
      }
    }
    AppStorage.setOrCreate<boolean>(VoiceConstant.isFullShown, isShow);
  }
}