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
import {
  LogDomain,
  LogHelper,
  NotificationConfigEvent
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import {
  NtfSettingSysEventReporter
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import { sSettingsUtil } from '@ohos/managementcomponent';
import {
  SettingsConstants,
  SettingsKeyConstants
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import ntfMngSelectComponent
  from '@ohos/managementcomponent/src/main/ets/com/ohos/view/component/ntfMngSelectComponent';
import { FunType, RecordType, TipsJumpUtils } from '../common/TipsJumpUtils';
import { common } from '@kit.AbilityKit';
import {
  notificationSettingManager
} from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/NotificationSettingManager';
import { SystemParameterUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/SystemParameterUtil';

const TAG = 'ManagementComponent-NtfDisplayContentSelectComponent'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const displayLockScreenNtfContent: Resource | string = $r('app.string.display_lock_Screen_notification_content');
const displayBannerNtfContent: Resource | string = $r('app.string.display_banner_notification_content');
/* 隐藏横幅通知内容设置的key */
const APP_NTF_CONFIG_HIDE_BANNER_CONTENT: string = 'app_ntf_config_hide_banner_content';
/* 默认关闭隐藏横幅通知内容开关 等于1为默认开启*/
const BANNER_NTF_HIDE_CONTENT: string = '0';
const IS_DEVICE_SUPPORT_SWING = SystemParameterUtil.DEVICE_SUPPORT_SWING;

export enum IsHideBannerContent {
  CLOSE = 0,
  OPEN = 1
}

const INDEX2DB: Map<number, string> = new Map([
  [0, '0'],
  [1, '2'],
  [2, '1']
]);

@Component
export default struct NtfDisplayContentSelectComponent {
  /**
   * 是否显示了解详情（仅支持消息随身及安装了玩机技巧的机型显示）
   */
  @State isShowLearnMore: boolean = false;
  @Prop isSupportSwingOnScreenLock: boolean;
  @Prop isFacialUnlockEnabled: boolean;
  @Prop isSupportSmartNtf: boolean = IS_DEVICE_SUPPORT_SWING;
  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  private displayLockScreenNtfOptions: Resource[] = this.isSupportSwingOnScreenLock ?
    [$r('app.string.always_display'), $r('app.string.display_when_unlocked'),
      $r('app.string.display_only_when_the_owner_is_looking')] :
    [$r('app.string.always_display'), $r('app.string.display_when_unlocked')];
  private displayBannerNtfOptions: Resource[] =
    [$r('app.string.always_display'), $r('app.string.display_only_when_the_owner_is_looking')];

  aboutToAppear(): void {
    log.showInfo(`AboutToAppear isSupportSmartNtf is ${this.isSupportSmartNtf}`);
    this.setShowLearnMoreVal()
    notificationSettingManager.subscribeChangeEvent(this.onNotificationConfigChange);
  }

  aboutToDisappear(): void {
    notificationSettingManager.unsubscribeChangeEvent(this.onNotificationConfigChange);
    log.showInfo('aboutToDisappear');
  }

  build() {
    Column() {
      this.buildDisplayNtf();
      if (this.isSupportSmartNtf) {
        this.buildOnlyWhenTheOwnerIsLookingTip();
      }
    }
  }

  @Builder
  buildDisplayNtf() {
    Column() {
      this.buildDisplayLockScreenNtfContent();
      if (this.isSupportSmartNtf) {
        this.buildNtfMgmtItemDivider();
        this.buildDisplayBannerNtfContent();
      }
    }
    .padding({ top: $r('app.float.noDisturb_margin_lf'), bottom: $r('app.float.noDisturb_margin_lf') })
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius($r('app.float.ntf_setting_item_card_radius'))
  }

  /**
   * 显示锁屏通知内容
   */
  @Builder
  buildDisplayLockScreenNtfContent() {
    ntfMngSelectComponent({
      title: displayLockScreenNtfContent,
      selectOptions: this.displayLockScreenNtfOptions,
      initializationAction: () => this.selectDisplayLockScreenNtfContentInit(),
      settingAction: (params?: number) => {
        if (params != undefined) {
          this.selectDisplayLockScreenNtfContent(params);
        }
      }
    })
  }

  @Builder
  buildNtfMgmtItemDivider() {
    Divider()
      .color($r('sys.color.comp_divider'))
      .strokeWidth('1px')
      .padding({ left: $r('app.float.switchComp_padding_r'), right: $r('app.float.switchComp_padding_r') })
  }

  /**
   * 显示横幅通知内容
   */
  @Builder
  buildDisplayBannerNtfContent() {
    ntfMngSelectComponent({
      title: displayBannerNtfContent,
      selectOptions: this.displayBannerNtfOptions,
      initializationAction: () => this.selectDisplayBannerNtfContentInit(),
      settingAction: (params?: number) => {
        if (params != undefined) {
          this.selectDisplayBannerNtfContent(params);
        }
      },
      isFacialUnlockEnabled: this.isFacialUnlockEnabled,
    })
  }

  /**
   * '仅机主注视时'tip
   */
  @Builder
  buildOnlyWhenTheOwnerIsLookingTip() {
    Row() {
      Text() {
        Span($r('app.string.only_when_the_owner_is_looking_tip', ' '));
        if (this.isShowLearnMore) {
          Span($r('app.string.only_when_the_owner_is_looking_tip_button'))
            .fontColor($r('sys.color.font_emphasize'))
            .onClick(this.jumpToTips)
        }
      }
      .width('100%')
      .fontSize(12)
      .maxFontScale(2)
      .fontFamily('HarmonyHeiTi')
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .fontWeight(FontWeight.Regular)
      .constraintSize({ minHeight: $r('app.float.ntf_hide_banner_txt_lineHeight') })
      .onClick(this.isAccessibilityMode ? this.jumpToTips : undefined)
    }.margin({ top: $r('app.float.ntf_hide_banner_txt_margin') })
    .width('100%')
    .padding({
      left: $r('app.float.ntf_hide_banner_txt_padding'),
      right: $r('app.float.ntf_hide_banner_txt_padding')
    })
  }

  private async setShowLearnMoreVal(): Promise<void> {
    this.isShowLearnMore = await TipsJumpUtils.isAppInstalled();
    log.showInfo(`isShowLearnMore: ${this.isShowLearnMore}`);
  }

  /**
   * 跳转玩机技巧
   */
  private jumpToTips = (): void => {
    log.showInfo(`jump to Tips`);
    NtfSettingSysEventReporter.bannerNotificationHidePageToTipsPage({});
    TipsJumpUtils.jumpTips(getContext(this) as common.UIAbilityContext, FunType.SMART_REMINDER,
      RecordType.SMART_REMINDER);
  }

  /**
   * 显示锁屏通知内容 初始化
   */
  async selectDisplayLockScreenNtfContentInit(): Promise<boolean> {
    return new Promise((resolve: (value: boolean | PromiseLike<boolean>) => void) => {
      const devValue: string = SettingsConstants.APP_NTF_HIDE_CONTENT_DEFAULT ? 'true' : 'false';
      let value = sSettingsUtil.getSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_HIDE_CONTENT, devValue);
      log.showInfo('selectDisplayLockScreenNtfContentInit: [%{public}s]', value);
      resolve(value === 'false');
    });
  }

  /**
   * 显示横幅通知内容 初始化
   * @returns
   */
  async selectDisplayBannerNtfContentInit(): Promise<boolean> {
    return new Promise((resolve: (value: boolean | PromiseLike<boolean>) => void) => {
      let value = sSettingsUtil.getSecureValue(APP_NTF_CONFIG_HIDE_BANNER_CONTENT, BANNER_NTF_HIDE_CONTENT);
      log.showInfo('selectDisplayBannerNtfContentInit: [%{public}s]', value);
      resolve(value === '0');
    });
  }

  private onNotificationConfigChange = async (event: NotificationConfigEvent): Promise<void> => {
    log.showInfo(`onNotificationConfigChange: eventType: ${event.type}`);
    this.setShowLearnMoreVal();
  }

  /**
   * 显示锁屏通知内容 选中项切换
   * @param index
   */
  selectDisplayLockScreenNtfContent(index: number): void {
    if (!INDEX2DB.get(index)) {
      log.showError(`invalid index:${index}`);
    }
    const configShowContentKgValue: string = INDEX2DB.get(index) ?? '';
    let resultHideContentKg: boolean =
      sSettingsUtil.setSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_HIDE_CONTENT, index ? 'true' : 'false');
    log.showInfo('selectDisplayLockScreenNtfContent: [%{public}d], result [%{public}s]', index, resultHideContentKg);
    let resultShowContentKg: boolean =
      sSettingsUtil.setSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_SHOW_CONTENT_KG, configShowContentKgValue);
    log.showInfo('selectDisplayLockScreenNtfContent: [%{public}s], result [%{public}s]', configShowContentKgValue, resultShowContentKg);
    NtfSettingSysEventReporter.notificationDisplayPreview({
      NTF_MORE_SETTING_DISPLAY_PREVIEW: index as 0 | 1
    });
  }

  /**
   * 显示横幅通知内容 选中项切换
   * @param index
   */
  selectDisplayBannerNtfContent(data: number): void {
    try {
      if (![0, 1].includes(data)) {
        log.showWarn('Illegal data');
        return;
      }
      NtfSettingSysEventReporter.bannerNotificationHideManagement({
        IS_HIDE_BANNER_CONTENT: data as 0 | 1,
      });
      const result: boolean =
        sSettingsUtil.setSecureValue(APP_NTF_CONFIG_HIDE_BANNER_CONTENT, data.toString());
      log.showInfo('SwitchSmartRemindNotificationContent. on: [%{public}d], set value result: [%{public}s]', data,
        result);
    } catch (e) {
      log.showError('set switch state err: %{public}s', e.message);
    }
  }
}