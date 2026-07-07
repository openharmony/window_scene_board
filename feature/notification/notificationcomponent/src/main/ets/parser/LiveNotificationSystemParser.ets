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

import { SystemUICommonUtil, SysTypeCode } from '@ohos/systemuicommon';
import {
  LiveCardSystemModel, LiveTimerModel, LiveProgressModel, LiveButtonModel, LiveCapsuleModel,
  LiveCapsuleTextModel, LiveCapsuleProgressModel, LiveCapsuleTimerModel, LiveStatus,
  LiveType, AppLifeCycleManager,
} from '@ohos/systemuicommon/newTsIndex';
import { LogDomain, LogHelper, ThreadUtil } from '@ohos/basicutils';
import { LiveNotificationBaseParser } from './LiveNotificationBaseParser';
import { LiveButtonState } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';
import { resourceManager } from '@kit.LocalizationKit';
import type { image } from '@kit.ImageKit';
import { ImmDataHelper } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/immersivekg/helper/ImmDataHelper';

interface NotificationIconButton {
  name: string;
  iconResource?: image.PixelMap | resourceManager.Resource;
  text?: string;
  hidePanel?: boolean;
}

const log = LogHelper.getLogHelper(LogDomain.NC, 'LiveNotificationSystemParser');

/**
 * 系统实况通知解析
 */
export class LiveNotificationSystemParser extends LiveNotificationBaseParser {
  protected isHeadsUp(): boolean {
    return this.ntf.remindConfig.isBannerEnable();
  }

  protected parseLiveViewCommonData(): void {
    super.parseLiveViewCommonData();
    this.ntf.typeCode = this.request.content.systemLiveView?.typeCode!;
    this.ntf.customerAccessibilityText = this.request?.extraInfo?.hw_customer_accessibility_text;
    if (this.ntf.isFromSystemApp) {
      this.ntf.isHeadsUpStick = this.request.extraInfo?.hw_keep_headsup_sticky === true;
    }
    this.ntf.stage = this.request.extraInfo?.stage;
    if (this.ntf.isPhoneCall()) {
      this.ntf.sysVOIPStatus = this.request.extraInfo?.SYS_VOIP_STATUS;
    }
  }

  protected getDuration(): number {
    const capsule = this.request.content.systemLiveView?.capsule;
    if (capsule?.time) {
      // 即时横幅采用应用传递的time，不做限制
      if (capsule?.time <= LiveNotificationBaseParser.DEFAULT_DURATION &&
        (this.request.content.systemLiveView?.liveViewType !== Number(LiveType.INSTANT_BANNER) &&
          this.request.content.systemLiveView?.typeCode !== Number(SysTypeCode.FACE_LOCK))) {
        return LiveNotificationBaseParser.DEFAULT_DURATION;
      }
      if (capsule?.time >= LiveNotificationBaseParser.MAX_DURATION) {
        return LiveNotificationBaseParser.MAX_DURATION;
      }
      return capsule?.time;
    }
    return LiveNotificationBaseParser.DEFAULT_DURATION;
  }

  protected parseCardData(): LiveCardSystemModel {
    const systemLiveView = this.request.content.systemLiveView;
    const cardData = new LiveCardSystemModel();

    cardData.title = systemLiveView?.title ?? '';
    cardData.content = systemLiveView?.text ?? '';
    log.showInfo(`system card info: ${cardData.title.length}, ${cardData.content.length}`);
    if (this.ntf.typeCode === SysTypeCode.PHONE) {
      cardData.simIconStatus = this.request.extraInfo?.hw_sim_icon_status;
    }

    this.parseTimeData(cardData);
    this.parseProgressData(cardData);
    this.parseButtonData(cardData);
    // 沉浸大卡数据解析
    this.parseImmersiveCardData(cardData);

    return cardData;
  }

  protected parseRemindFlag(): void {
    this.ntf.remindConfig.setBanner(this.request.extraInfo?.hw_heads_up_enable === true ||
      (this.request.content.systemLiveView?.typeCode === SysTypeCode.NAME_THAT_TUNE &&
        this.request.extraInfo?.hw_remind));
    this.ntf.isSoundEnable = this.request.extraInfo?.isMute === false;
    this.ntf.isVibrationEnable = this.request.extraInfo?.isMute === false;
  }

  private parseTimeData(cardData: LiveCardSystemModel): void {
    const time = this.request.content.systemLiveView?.time;
    if (!time) {
      return;
    }

    const oldTimer = this.oldNtf?.card?.isSystemCard() ? this.oldNtf.card.timer : undefined;
    let extraInfoInitialTime: number | undefined = undefined;

    // 如果不带initialTime，且未改变timer信息则表示不需要更新计时器，使用上一次的计时器对象
    if (time.initialTime === undefined && oldTimer) {
      cardData.timer = oldTimer;
    } else {
      cardData.timer = new LiveTimerModel(`LiveSystemTimer_${this.request.hashCode}`);
      if (!ThreadUtil.isMainThread) {
        // 子线程单独重启场景，录屏的initialTime没有值，需要使用extraInfo中的值进行恢复
        extraInfoInitialTime = this.request?.extraInfo?.initialTime;
      }
      cardData.timer.initialTime = time.initialTime ?? extraInfoInitialTime ?? 0;
    }
    cardData.timer.requestInitialTime = time.initialTime ?? extraInfoInitialTime;
    cardData.timer.isCountdown = time.isCountDown ?? false;
    cardData.timer.isPaused = time.isPaused ?? false;
    cardData.isTimerInTitle = time.isInTitle ?? false;
    log.info('System timer:', cardData.timer);
  }

  private parseProgressData(cardData: LiveCardSystemModel): void {
    const progress = this.request.content.systemLiveView?.progress;
    if (!progress) {
      return;
    }

    const progressData = new LiveProgressModel();
    progressData.maxValue = progress.maxValue ?? 1;
    progressData.currentValue = progress.currentValue ?? 0;
    progressData.isPercentage = progress.isPercentage ?? true;
    if (typeof this.request.extraInfo?.hw_live_process_color === 'string') {
      progressData.color = this.request.extraInfo?.hw_live_process_color;
    }
    cardData.progress = progressData;
  }

  private parseButtonData(cardData: LiveCardSystemModel): void {
    const buttons = this.convertCardButton();
    // 最大显示3个按钮，如果有进度按钮则还要减少一个
    const buttonMaxCount = Math.min(this.request.content.systemLiveView?.progress ? 2 : 3, buttons.length);
    buttons.splice(buttonMaxCount);
    if (!buttons.length) {
      return;
    }
    cardData.buttonPriority = this.request.extraInfo?.hw_button_priority ?? [];
    const buttonAccessibilityText: string[] = this.request.extraInfo?.hw_button_accessibility_text ?? [];
    const buttonOnOffState: string[] = this.request.extraInfo?.hw_button_state_on ?? [];
    const cardButtons: LiveButtonModel[] = [];

    for (let i = 0; i < buttons.length; i++) {
      const button = this.parseButton(buttons[i]);
      if (typeof buttonAccessibilityText[i] === 'string') {
        button.accessibilityText = buttonAccessibilityText[i];
      }
      if (buttonOnOffState[i] === LiveButtonState.ON || buttonOnOffState[i] === LiveButtonState.OFF) {
        button.onOffState = buttonOnOffState[i] as LiveButtonState;
      }
      cardButtons.push(button);
    }
    cardData.buttons = cardButtons;
  }

  /**
   * 系统实况沉浸卡片数据解析
   *
   * @param cardData 实况卡片数据
   */
  private parseImmersiveCardData(cardData: LiveCardSystemModel): void {
    // 当前情景模式实现沉浸大卡
    if (!this.ntf?.isScenario()) {
      return;
    }
    // 标示沉浸态权益值
    let lockScreenVal = -1;
    if (this.request.content?.liveView?.extraInfo?.['eventControl']) {
      try {
        lockScreenVal = (JSON.parse(this.request?.content?.liveView?.extraInfo?.['eventControl'] as string ?? '')?.[
        'lockScreen']) as number ?? -1;
      } catch (err) {
        log.showError(`eventControl json parse failed.`);
      }
    }
    log.showInfo(`eventControl json parse success. lockScreenVal:${lockScreenVal}`);
    // 情景模式默认支持进入沉浸态
    cardData.immersiveCardAuthLevel = this.ntf?.isScenario() ? 1 : lockScreenVal;
    // UIExtension检测
    let immAbilityName:string = this.request?.extraInfo?.['PrimaryData.immersiveAbilityName'] as string;
    let immParameters: Record<string, Object> = this.request?.extraInfo?.['PrimaryData.immersiveParameters'] ?? {};
    if (!immAbilityName) {
      log.showWarn('parseImmersiveCardData intelligent has not extra ability.');
      return;
    }
    if (!immParameters) {
      immParameters = {};
    }
    // 当前固定情景模式包名
    let bundleName = ImmDataHelper.INTELLIGENT_BUNDLE_NAME;
    immParameters.id = this.ntf.id;
    // 标示沉浸类型
    immParameters['ability.want.params.uiExtensionType'] = ImmDataHelper.EXT_ABILITY_TYPE_IMMERSIVE as Object;
    // 标示是否允许UIExtension交互
    cardData.isImmersiveInteraction = (immParameters.isSupportInteraction ?? '0') !== '0' || cardData.immersiveCardAuthLevel === 3;
    // UIExtension交互白名单
    if (ImmDataHelper.getInstance().isSupportInteraction(bundleName)) {
      cardData.isImmersiveInteraction = true;
    }
    // 标示是否允许常亮
    cardData.isKeepScreenOnEnable = String(immParameters['hw_live_view_keep_screen_on']).toString() === 'true';
    // 标示UIExtension的加载want
    cardData.immersiveWant = {
      bundleName: bundleName,
      abilityName: immAbilityName,
      parameters: immParameters
    };
  }

  protected parseCapsuleData(): LiveCapsuleModel | undefined {
    const capsule = this.request.content.systemLiveView?.capsule;
    if (!capsule) {
      return undefined;
    }

    const capsuleSticky = (this.ntf.isFromSystemApp && this.request.extraInfo?.hw_capsule_sticky) === true;

    if (AppLifeCycleManager.instance.appSwitchObserverId === undefined &&
    this.ntf.isDeliverNotification && !capsuleSticky) {
      log.showWarn(`DeliverApp ${this.ntf.hashCode} App ${this.ntf.creatorBundleName}_${this.ntf.creatorUid} ` +
        'no need capsule, appSwitchObserverId is undefined');
      return undefined;
    }

    const cardData = this.ntf.card as LiveCardSystemModel;
    let capsuleData: LiveCapsuleModel;
    if (cardData.timer) {
      capsuleData = new LiveCapsuleTimerModel();
      (capsuleData as LiveCapsuleTimerModel).timer = cardData.timer;
      (capsuleData as LiveCapsuleTimerModel).content = capsule.content;
    } else if (cardData.progress) {
      capsuleData = new LiveCapsuleProgressModel();
      let progress = cardData.progress;
      if (typeof this.request.extraInfo?.hw_capsule_process_color === 'string') {
        progress.color = this.request.extraInfo?.hw_capsule_process_color;
      }
      (capsuleData as LiveCapsuleProgressModel).progress = progress;
      if (this.ntf.typeCode === SysTypeCode.CHARGE) {
        (capsuleData as LiveCapsuleProgressModel).content = capsule.content;
      }
    } else {
      capsuleData = new LiveCapsuleTextModel();
      (capsuleData as LiveCapsuleTextModel).content = capsule.content;
    }

    capsuleData.title = capsule.title ?? '';
    if (capsule.capsuleButtons?.length) {
      let buttons: NotificationIconButton[] = capsule.capsuleButtons;
      capsuleData.button = this.parseButton(buttons[0]);
    }
    capsuleData.icon = capsule.icon;
    capsuleData.backgroundColor = capsule.backgroundColor;
    // 强提醒更新需要记录更新时间，用于实况显示优先级排序
    if (this.ntf.remindConfig.isBannerEnable() || this.ntf.remindConfig.isCapsuleFlip()) {
      this.ntf.createTime = this.ntf.deliveryTime;
    }
    capsuleData.sticky = capsuleSticky;
    // 设置Ability销毁时隐藏胶囊，解决通话挂断时胶囊闪烁的问题
    if (this.ntf.typeCode === SysTypeCode.PHONE) {
      capsuleData.hideWhenRemoveSession = this.request.extraInfo?.hw_capsule_hidden_when_terminate === true;
    }
    this.parseScreenRecordInfo(capsuleData);
    this.parseMediaPlayerInfo(capsuleData);
    log.info(`live capsule data parse end: ${this.ntf.hashCode}`, this.getCapsuleDataParseLog(capsuleData));
    return capsuleData;
  }

  private getCapsuleDataParseLog(capsuleData: LiveCapsuleModel | undefined): Record<string, Object> {
    const result: Record<string, Object> = {};
    if (this.request.content.systemLiveView?.capsule?.capsuleButtons?.length) {
      result.capsuleButton = this.request.content.systemLiveView?.capsule?.capsuleButtons?.length;
    }
    if (this.ntf?.duration) {
      result.time = this.ntf?.duration;
    }
    if (capsuleData?.sticky) {
      result.sticky = capsuleData?.sticky;
    }
    if (this.ntf?.type) {
      result.liveViewType = this.ntf?.type;
    }
    if (this.ntf.typeCode) {
      result.TypeCode = this.ntf.typeCode;
    }
    if (capsuleData?.button?.name) {
      result.name = capsuleData?.button?.name;
    }
    if (capsuleData?.button?.hidePanel) {
      result.hidePanel = capsuleData?.button?.hidePanel;
    }
    if (capsuleData?.button?.text) {
      result.text = capsuleData?.button?.text;
    }
    if (capsuleData?.button?.iconResource?.id) {
      result.iconResource = capsuleData?.button?.iconResource?.id;
    }
    if (capsuleData?.isTimer()) {
      result.timerUid = (capsuleData as LiveCapsuleTimerModel)?.timer?.uid ?? '';
    }
    return result;
  }

  private parseButton(button: NotificationIconButton): LiveButtonModel {
    const cardButton = new LiveButtonModel();
    cardButton.name = button.name;
    cardButton.hidePanel = button.hidePanel;
    cardButton.text = button.text;
    if (!this.isIconPixelMap(button.iconResource)) {
      cardButton.iconResource = button.iconResource as resourceManager.Resource;
      if (!this.checkRes(cardButton.iconResource.bundleName)) {
        return cardButton;
      }
      this.bundleResourceParser.addMediaImage(cardButton.iconResource, (result) => {
        cardButton.lightIcon = result.light;
        cardButton.darkIcon = result.dark;
      });
    } else {
      const icon = button.iconResource as image.PixelMap;
      SystemUICommonUtil.setPixelMapName(icon, `${this.ntf.hashCode}_pixelMap_cardButton`);
      cardButton.lightIcon = icon;
      cardButton.darkIcon = icon;
    }
    log.showInfo(`cardButton info: name:${cardButton.name} hidePanel:${cardButton.hidePanel} text:${cardButton.text}`);
    return cardButton;
  }

  private checkRes(bundleName: string): boolean {
    // 校验resource合法性
    if (!(bundleName === this.request.creatorBundleName || bundleName === this.request?.agentBundle?.bundle)) {
      log.showInfo(`Invalid resource object [${bundleName}] `);
      return false;
    }
    return true;
  }

  private isIconPixelMap(icon?: image.PixelMap | resourceManager.Resource): boolean {
    return typeof (icon as image.PixelMap)?.getImageInfo === 'function';
  }

  private convertCardButton(): NotificationIconButton[] {
    const button = this.request.content.systemLiveView?.button;
    const cardButtons: NotificationIconButton[] = this.request.content.systemLiveView?.cardButtons ?? [];
    if (cardButtons.length) {
      return cardButtons;
    }
    if (!button?.names?.length) {
      return cardButtons;
    }
    for (let i = 0; i < button.names.length; i++) {
      if (!button.names[i] || (!button.iconsResource?.[i] && !button.icons?.[i])) {
        log.showError(`Invalid button icon of ${this.request.hashCode}, button name: ${button.names[i]}`);
        continue;
      }
      cardButtons.push({
        name: button.names[i],
        iconResource: button.iconsResource?.[i] ? button.iconsResource?.[i] : button.icons?.[i],
      });
    }
    return cardButtons;
  }

  private parseMediaPlayerInfo(capsuleData: LiveCapsuleModel): void {
    // 播控的切歌动效定制
    if (this.ntf.typeCode === SysTypeCode.BROADCASTING_CENTER) {
      capsuleData.iconAnimationType = this.request.extraInfo?.hw_capsule_icon_animation_type;
    }
  }

  private parseScreenRecordInfo(capsuleData: LiveCapsuleModel): void {
    // 录屏的胶囊按钮定制
    if (this.ntf.typeCode === SysTypeCode.SCREEN_RECORDING && !capsuleData.button) {
      const cardButtons = this.ntf.card?.isSystemCard() ? this.ntf.card.buttons : [];
      if (cardButtons?.length) {
        const lastButton = cardButtons[cardButtons.length - 1];
        capsuleData.button = new LiveButtonModel();
        capsuleData.button.name = lastButton.name;
        capsuleData.button.lightIcon = capsuleData.icon;
        capsuleData.button.darkIcon = capsuleData.icon;
        capsuleData.button.accessibilityText = lastButton.accessibilityText;
      }
    }
  }
}