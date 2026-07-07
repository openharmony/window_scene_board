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

import {
  BaseNotification,
  baseStateMgr,
  IComponentData, IImmersiveData,
  ImmersiveKgParserCtrlType, LiveBaseTemplate, LiveButtonArray, LiveButtonData,
  LiveCapsuleData, LiveExtendType, LiveNavigationTemplate, LiveOtherExtendData,
  LivePickUpTemplate, LiveProgressData, LiveScoreTemplate, LiveSystemTemplate,
  LiveTimerData, LiveViewData,
  NotificationAction,
  NtfReminderConfig,
  ObservedItem,
  OtherBaseTemplate, ParserController, parserCtrlMgr, RichText,
} from '@ohos/systemuicommon';
import { LiveCardFlightModel, LiveCardNavigationModel, LiveCardOtherModel, LiveCardPickupModel,
  LiveCardProgressModel, LiveCardScoreModel, LiveCardSystemModel, LiveNotification,
  LiveProgressModel, LiveRichTextModel, LiveTimerModel, NormalNotification, NotificationBase, NotificationUtil,
} from '@ohos/systemuicommon/newTsIndex';
import { NotificationEntry } from '../model/NotificationEntry';
import { notificationManager } from '@kit.NotificationKit';
import { LiveFlightTemplate } from '@ohos/systemuicommon/src/main/ets/liveview/data/template/LiveFlightTemplate';
import { LiveProgressTemplate } from '@ohos/systemuicommon/src/main/ets/liveview/data/template/LiveProgressTemplate';
import { CapsuleRemindType, CapsuleType,
  LiveType,
  LiveViewDataStatus } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';
import { NtfControlConfig } from '@ohos/systemuicommon/src/main/ets/model/NtfControlFlags';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { systemSoundManager } from '@kit.AudioKit';

const log = LogHelper.getLogHelper(LogDomain.NC, 'NotificationCompatibleConverter');

/**
 * 新通知数据结构兼容老通知结构的转换器
 */
export class NotificationCompatibleConverter {
  public static convert(ntf: NotificationBase, request: notificationManager.NotificationRequest): NotificationEntry {
    const entry = new NotificationEntry();
    entry.request = request;
    NotificationCompatibleConverter.convertBase(ntf, entry);
    if (ntf.isNormal()) {
      NotificationCompatibleConverter.convertNormal(ntf, entry);
    } else if (ntf.isLiveView()) {
      NotificationCompatibleConverter.convertLiveView(ntf, entry);
    }
    NotificationCompatibleConverter.convertImmersive(entry);
    entry.request = undefined;

    return entry;
  }

  public static recoverLiveMethod(ntf: LiveNotification): void {

  }

  public static recoverNtfMethod(ntf: NotificationBase): void {
    ntf.controlConfig = new NtfControlConfig(ntf.controlConfig?.flags ?? 0);
    ntf.remindConfig = new NtfReminderConfig(ntf.remindConfig?.flags);
  }

  private static convertBase(ntf: NotificationBase, entry: NotificationEntry): void {
    entry.id = ntf.id;
    entry.hashCode = ntf.hashCode;
    entry.slotType = ntf.slotType;
    entry.isOngoing = ntf.isOngoing;
    entry.isAutoDelete = ntf.isAutoDelete;
    entry.isShowHeadsUp = ntf.isHeadsUp;
    entry.isHeadsUpStick = ntf.isHeadsUpStick;
    entry.isRemoveAllowed = ntf.isRemoveAllowed;
    entry.isNoClear = !ntf.isClearAllowed;
    entry.isAlertOnce = ntf.isAlertOnce;
    entry.isFloatingIcon = ntf.isShowStatusBarIcon;
    entry.isDisplayAtTop = ntf.isDisplayAtTop;
    entry.creatorBundleName = ntf.creatorBundleName;
    entry.creatorUserId = ntf.creatorUserId;
    entry.creatorUid = ntf.creatorUid;
    entry.agentBundle = ntf.agentBundle;
    entry.appLabel = ntf.appLabel;
    entry.appName = new ObservedItem(entry.appLabel);
    entry.appIcon = ntf.appIcon;
    entry.largeIcon = ntf.largeIcon;
    entry.smallIcon = ntf.smallIcon;
    entry.smallIconOrigin = ntf.smallIconOrigin;
    entry.overlayIcon = ntf.overlayIcon;
    entry.wantAgent = ntf.wantAgent;
    entry.wantAgentInfo = ntf.wantAgentInfo;
    entry.deliveryTime = ntf.deliveryTime;
    // entry.autoDeletedTime 用不上
    entry.isDeliverNotification = ntf.isDeliverNotification;
    entry.deliverNotificationKey = ntf.deliverNotificationKey;
    entry.isDeliverPushNotification = ntf.isDeliverPushNotification;
    entry.groupName = (ntf.isLiveView() || ntf.isEmergencyNtf()) ? ntf.hashCode : ntf.groupName ?? '';
    // isBypassDnd 用不上
    entry.sound = ntf.sound;
    entry.soundDescriptor = ntf.customSound;
    entry.soundDuration = ntf.soundDuration;
    entry.vibration = ntf.vibration;
    entry.remindConfig = ntf.remindConfig;
    entry.isLockScreenEnable = ntf.isLockScreenEnable;
    entry.isSoundEnable = ntf.isSoundEnable;
    entry.isVibrationEnable = ntf.isVibrationEnable;
    entry.slotLevel = ntf.slotLevel;
    entry.systemToneType = ntf.systemToneType ?? systemSoundManager.SystemToneType.SYSTEM_TONE_TYPE_NOTIFICATION;
    entry.isFromSystemApp = ntf.isFromSystemApp;
    entry.isSettingIgnore = ntf.isSettingIgnore;
    entry.creatorType = ntf.creatorType;
    entry.bundleType = ntf.bundleType;
    entry.isFromPush = ntf.isFromPush;
    entry.appIndex = ntf.appIndex;
    entry.controlConfig = ntf.controlConfig;
    entry.pushData = ntf.pushData;
    entry.actionButtons = ntf.actionButtons ?? [];
    entry.channelId = ntf.channelId;
    entry.contentType = ntf.contentType;
    entry.bundleIdxTag = `${ntf.creatorBundleName}_${ntf.appIndex}`;
    entry.overlayIconStyle = ntf.overlayIconStyle;
    entry.deliverInstallSource = ntf.deliverInstallSource;
    entry.isDeliverFullScreen = ntf.isDeliverFullScreen;
    entry.deliverAbilityName = ntf.deliverAbilityName;
    entry.deliverPushWantAgentInfo = ntf.deliverPushWantAgentInfo;
    entry.deliverPushLauncherInfo = ntf.deliverPushLauncherInfo;
    entry.channelId = ntf.channelId;
    entry.traceId = ntf.traceId;
  }

  private static convertNormal(ntf: NormalNotification, entry: NotificationEntry): void {
    entry.contentType = ntf.contentType;
    entry.isExpandable = NotificationCompatibleConverter.converNormalIsExpandable(ntf);
    entry.notificationContent = ntf.content;
  }

  private static converNormalIsExpandable(ntf: NormalNotification): boolean {
    if (ntf.contentType === notificationManager.ContentType.NOTIFICATION_CONTENT_LONG_TEXT ||
      ntf.contentType === notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE ||
      ntf.contentType === notificationManager.ContentType.NOTIFICATION_CONTENT_PICTURE) {
      return true;
    }
    return (ntf.actionButtons?.length ?? 0) > 0;
  }
  
  private static convertLiveView(ntf: LiveNotification, entry: NotificationEntry): void {
    entry.isConvertFromNormal = ntf.isConvertFromNormal;
    entry.liveViewData = new LiveViewData();
    entry.liveViewData.type = ntf.type;
    entry.liveViewData.hashCode = entry.hashCode;
    entry.liveViewData.creatorBundleName = entry.creatorBundleName;
    entry.liveViewData.creatorUid = entry.creatorUid;
    entry.liveViewData.agentBundle = entry.agentBundle;

    entry.liveViewData.deliveryTime = ntf.deliveryTime;
    entry.liveViewData.createTime = ntf.createTime;
    entry.liveViewData.id = ntf.id;
    // keepTime 在ANS处理，上层不需要处理
    entry.liveViewData.isRemoveAllowed = ntf.isRemoveAllowed;
    entry.liveViewData.isEditSwitchAllowed = !ntf.isSettingIgnore;
    entry.liveViewData.setDataTimeout(ntf.isEnd);
    entry.liveViewData.status = ntf.isEnd ? LiveViewDataStatus.END : LiveViewDataStatus.CREATE;
    entry.liveViewData.liveType = ntf.card?.cardType as number as LiveType;
    entry.liveViewData.sysTypeCode = ntf.typeCode;
    entry.liveViewData.groupKey = entry.getGroupKey();
    if (ntf.card?.isOtherCard()) {
      entry.liveViewData.showAuthorization = ntf.card.isShowAuthorization;
    }
    entry.liveViewData.appIndex = ntf.appIndex;
    entry.liveViewData.appName = new ObservedItem(ntf.appLabel);
    entry.liveViewData.isAtomicServiceFromPush = ntf.isAtomicServiceFromPush;
    entry.liveViewData.isDeliverNotification = ntf.isDeliverNotification;
    entry.liveViewData.setCustomerAccessibilityText(ntf.customerAccessibilityText);

    if (ntf.card?.isSystemCard()) {
      NotificationCompatibleConverter.convertLiveViewSystemTemplate(ntf, entry);
    } else if (ntf.card?.isFlightCard()) {
      NotificationCompatibleConverter.convertFlightTemplate(ntf, entry);
    } else if (ntf.card?.isNavigationCard()) {
      NotificationCompatibleConverter.convertNavigationTemplate(ntf, entry);
    } else if (ntf.card?.isPickupCard()) {
      NotificationCompatibleConverter.convertPickupTemplate(ntf, entry);
    } else if (ntf.card?.isProgressCard()) {
      NotificationCompatibleConverter.convertProgressTemplate(ntf, entry);
    } else if (ntf.card?.isScoreCard()) {
      NotificationCompatibleConverter.convertScoreTemplate(ntf, entry);
    } else if (ntf.card?.isNoLayoutCard()) {
      NotificationCompatibleConverter.convertOtherBaseTemplate(ntf, entry, new OtherBaseTemplate());
    }

    NotificationCompatibleConverter.convertCapsule(ntf, entry);
  }
  
  private static convertLiveViewSystemTemplate(ntf: LiveNotification, entry: NotificationEntry): void {
    const card = ntf.card as LiveCardSystemModel;
    const template = new LiveSystemTemplate();
    if (entry.liveViewData) {
      entry.liveViewData.template = template;
    }
    template.setTitle(card.title);
    template.setContent(card.content);
    template.setOverlayIcon(ntf.overlayIcon);
    template.setSimIconStatus(card.simIconStatus);
    NotificationCompatibleConverter.convertBaseTemplate(ntf, entry);

    if (card.timer) {
      const liveTimerData = NotificationCompatibleConverter.convertTimer(card.timer, card.isTimerInTitle);
      template.setExtendData(LiveExtendType.TYPE_COMMON_TIMER, liveTimerData);
    }
    if (card.progress) {
      template.setExtendData(LiveExtendType.TYPE_COMMON_PROGRESS,
        NotificationCompatibleConverter.convertProgress(card.progress));
    }
    if (card.buttons) {
      const liveButtonArray = new LiveButtonArray();
      liveButtonArray.buttonPriority = card.buttonPriority;
      for (const button of card.buttons) {
        const buttonData = new LiveButtonData();
        buttonData.hashCode = ntf.hashCode;
        buttonData.setId(ntf.id);
        buttonData.setButtonName(button.name);
        buttonData.lightIcon = button.lightIcon;
        buttonData.darkIcon = button.darkIcon;
        buttonData.setButtonIcon(baseStateMgr.isDarkMode() ? button.darkIcon : button.lightIcon);
        buttonData.setButtonState(button.onOffState);
        buttonData.setIconResource(button.iconResource);
        buttonData.setAccessibilityText(button.accessibilityText);
        buttonData.setBundle(ntf.agentBundle ?? { bundle: ntf.creatorBundleName, uid: ntf.creatorUid });
        liveButtonArray.push(buttonData);
      }
      template.setExtendData(LiveExtendType.TYPE_COMMON_BUTTON, liveButtonArray);
    }
  }

  private static convertBaseTemplate(ntf: LiveNotification, entry: NotificationEntry): void {
    const template = entry.liveViewData?.template as LiveBaseTemplate;
    template.setAppIcon(ntf.appIcon);
    template.setSmallIcon(ntf.smallIcon);
    template.setOverlayIconStyle(ntf.overlayIconStyle);
    template.setWantAgent(ntf.wantAgent);
    template.wantAgentInfo = ntf.wantAgentInfo;
    template.setIsDeliverLiveNotification(ntf.isDeliverNotification);
  }

  private static convertOtherBaseTemplate(ntf: LiveNotification, entry: NotificationEntry,
    template: OtherBaseTemplate): void {
    const card = ntf.card as LiveCardOtherModel;
    if (entry.liveViewData) {
      entry.liveViewData.template = template;
    }

    NotificationCompatibleConverter.convertBaseTemplate(ntf, entry);
    template.setTitle(card.fixedTitle);
    template.setLayoutType(card.cardType as number as LiveType);
    template.setLiveEvent(card.event);
    template.setStyle(card.style);
    template.setRichContent(NotificationCompatibleConverter.convertRichText(card.fixedContent));
    if (card.timer) {
      template.setIsTimeTemplate(true);
      template.setLiveTimer(NotificationCompatibleConverter.convertTimer(card.timer));
    }

    const extendData = new LiveOtherExtendData();
    extendData.setText(card.extensionText);
    extendData.setType(card.extensionType);
    extendData.setPic(card.extensionPic);
    extendData.setPicRes(card.extensionPicRes);
    if (card.extensionWantAgent) {
      extendData.setWantAgent(card.extensionWantAgent);
    } else {
      extendData.setWantAgent(ntf.wantAgent);
    }
    template.setExtendData(LiveExtendType.TYPE_OTHER_EXTEND, extendData);

    template.setServiceButtons(card.serviceButtons.map(button => new NotificationAction({
      title: button.actionTitle,
      wantAgent: button.wantAgent ?? ntf.wantAgent,
    })));
  }
  
  private static convertFlightTemplate(ntf: LiveNotification, entry: NotificationEntry): void {
    const cardData = ntf.card as LiveCardFlightModel;
    const template = new LiveFlightTemplate();
    template.setFirstTitle(cardData.layoutFirstTitle);
    template.setFirstContent(cardData.layoutFirstContent);
    template.setLastTitle(cardData.layoutLastTitle);
    template.setLastContent(cardData.layoutLastContent);
    template.setLastTitleSuperscript(cardData.layoutLastTitleSuperscript);
    template.setLastContentSuperscript(cardData.layoutLastContentSuperscript);
    template.setSpaceType(cardData.layoutSpaceType);
    template.setSpaceText(cardData.layoutSpaceText);
    template.setWeatherInfo(cardData.liveCardWeatherInfo);
    template.setSpaceIcon(cardData.layoutSpaceIcon);
    template.setSpaceIconRes(cardData.layoutSpaceIconRes);
    template.setDisplayHorizontalLine(cardData.layoutIsDisplayHorizontalLine);
    template.setAdditionalText(cardData.layoutAdditionalText);
    NotificationCompatibleConverter.convertOtherBaseTemplate(ntf, entry, template);
  }

  private static convertNavigationTemplate(ntf: LiveNotification, entry: NotificationEntry): void {
    const cardData = ntf.card as LiveCardNavigationModel;
    const template = new LiveNavigationTemplate();
    template.setCurrNavDirectionIcon(cardData.layoutCurrentNavigationIcon);
    template.setNavDirectionIconsFromPixel(cardData.layoutNavigationIcons);
    template.setIsNavigationIconsDisplayed(cardData.layoutIsNavigationIconsDisplayed);
    template.setDisplayHorizontalLine(cardData.layoutIsDisplayHorizontalLine);
    template.setNavigationIconMimeType(cardData.layoutNavigationIconMimeType);
    NotificationCompatibleConverter.convertOtherBaseTemplate(ntf, entry, template);
  }

  private static convertPickupTemplate(ntf: LiveNotification, entry: NotificationEntry): void {
    const cardData = ntf.card as LiveCardPickupModel;
    const template = new LivePickUpTemplate();
    template.setExtendTitle(cardData.layoutTitle);
    template.setExtendContent(cardData.layoutContent);
    template.setUnderlineColor(cardData.layoutUnderlineColor);
    template.setProviderName(cardData.layoutProviderName);
    template.setDescPic(cardData.layoutDescPic);
    NotificationCompatibleConverter.convertOtherBaseTemplate(ntf, entry, template);
  }

  private static convertProgressTemplate(ntf: LiveNotification, entry: NotificationEntry): void {
    const cardData = ntf.card as LiveCardProgressModel;
    const template = new LiveProgressTemplate();
    template.setProgress(cardData.layoutProgress);
    template.setColor(cardData.layoutColor);
    template.setBackgroundColor(cardData.layoutBackgroundColor);
    template.setLineType(cardData.layoutLineType);
    template.setIndicatorType(cardData.layoutIndicatorType);
    template.setIndicatorIcon(cardData.layoutIndicatorIcon);
    template.setNodeIcons(cardData.layoutNodeIcons);
    NotificationCompatibleConverter.convertOtherBaseTemplate(ntf, entry, template);
  }

  private static convertScoreTemplate(ntf: LiveNotification, entry: NotificationEntry): void {
    const cardData = ntf.card as LiveCardScoreModel;
    const template = new LiveScoreTemplate();
    template.setHostName(cardData.layoutHostName);
    template.setHostIcon(cardData.layoutHostIcon);
    template.setHostScore(cardData.layoutHostScore);
    template.setGuestName(cardData.layoutGuestName);
    template.setGuestIcon(cardData.layoutGuestIcon);
    template.setGuestScore(cardData.layoutGuestScore);
    template.setCompetitionDesc(NotificationCompatibleConverter.convertRichText(cardData.layoutCompetitionDesc));
    template.setCompetitionTime(cardData.layoutCompetitionTime);
    template.setDisplayHorizontalLine(cardData.layoutIsDisplayHorizontalLine);
    NotificationCompatibleConverter.convertOtherBaseTemplate(ntf, entry, template);
  }

  private static convertCapsule(ntf: LiveNotification, entry: NotificationEntry): void {
    if (!ntf.capsule) {
      return;
    }
    const template = entry.liveViewData?.template as LiveSystemTemplate;
    const capsuleData = ntf.capsule;
    const capsule: LiveCapsuleData = new LiveCapsuleData();
    capsule.setBundleName(ntf.creatorBundleName);
    capsule.setUid(ntf.creatorUid);
    capsule.setHashCode(ntf.hashCode);
    if (capsuleData.icon) {
      capsule.setCapsuleIcon(capsuleData.icon);
    } else {
      capsule.setCapsuleIcon(ntf.getAppIcon(true));
    }
    capsule.setBackgroundColor(capsuleData.backgroundColor);
    capsule.setCapsuleTypeCode(ntf.typeCode);
    capsule.setCapsuleStatus(capsuleData.status as number);
    capsule.setCapsuleHidden(capsuleData.hideWhenRemoveSession);
    capsule.setCapsuleRemind(NotificationCompatibleConverter.convertRemind(ntf.remindConfig,
      ntf?.card?.isSystemCard()));
    capsule.setCapsuleSticky(capsuleData.sticky);
    capsule.setCapsuleTitle(capsuleData.title);
    if (capsuleData.isText()) {
      capsule.setCapsuleType(CapsuleType.TYPE_TEXT);
      capsule.setCapsuleTitle(capsuleData.title);
      capsule.setCapsuleExtend(capsuleData.content);
      capsule.setIsContentDisplayed(capsuleData.isContentDisplayed);
    } else if (capsuleData.isTimer()) {
      capsule.setCapsuleType(CapsuleType.TYPE_TIMER);
      capsule.setCapsuleTypeData(NotificationCompatibleConverter.convertTimer(capsuleData.timer,
        ntf.card?.isSystemCard() ? ntf.card?.isTimerInTitle : true));
      capsule.setCapsuleExtend(capsuleData.content);
      capsule.setIsContentDisplayed(capsuleData.isContentDisplayed);
    } else if (capsuleData.isProgress()) {
      capsule.setCapsuleType(CapsuleType.TYPE_PROGRESS);
      capsule.setCapsuleTypeData(NotificationCompatibleConverter.convertProgress(capsuleData.progress));
    }
    entry.liveViewData?.setCapsule(capsule);
  }
  
  private static convertTimer(timerData: LiveTimerModel | undefined, isTimerInTitle = true): LiveTimerData | undefined {
    if (!timerData) {
      return undefined;
    }
    const liveTimerData = new LiveTimerData();
    liveTimerData.setInitialTime(timerData.requestInitialTime);
    liveTimerData.setCountDown(timerData.isCountdown);
    liveTimerData.setPause(timerData.isPaused);
    liveTimerData.setInTitle(isTimerInTitle);
    liveTimerData.setIsUpdateTimer(timerData.isUpdateTimer);
    return liveTimerData;
  }

  private static convertRichText(liveViewRichTextArr: LiveRichTextModel[]): RichText[] {
    return liveViewRichTextArr?.map((r) => {
      const richText = new RichText();
      richText.text = r.text;
      richText.oriTextColor = r.textColor;
      return richText;
    });
  }

  private static convertProgress(progressData: LiveProgressModel | undefined): LiveProgressData {
    const liveProgressData = new LiveProgressData();
    liveProgressData.setMaxValue(progressData?.maxValue);
    liveProgressData.setCurrentValue(progressData?.currentValue);
    liveProgressData.setPercentage(progressData?.isPercentage);
    liveProgressData.setProgressColor(progressData?.color);
    return liveProgressData;
  }

  private static convertRemind(remindConfig: NtfReminderConfig, isSystemCard?: boolean): CapsuleRemindType {
    // CapsuleRemindType为三方实况使用,系统不涉及Flip 横幅直接取isHeadsUp
    if (remindConfig.isBannerEnable() && !isSystemCard) {
      return CapsuleRemindType.EXPAND;
    }
    if (remindConfig.isCapsuleFlip() && !isSystemCard) {
      return CapsuleRemindType.FLIP;
    }
    return CapsuleRemindType.DEFAULT;
  }

  private static convertImmersive(entry: NotificationEntry): void {
    const immersiveNtfParser: ParserController<BaseNotification, IImmersiveData> | undefined =
      parserCtrlMgr.getParserController(ImmersiveKgParserCtrlType.TYPE_IMMERSIVE_NTF_DATA);
    entry.immersiveNtfData = immersiveNtfParser?.parse(entry)!;

    const immersiveKgParser: ParserController<notificationManager.NotificationRequest, IComponentData> | undefined =
      parserCtrlMgr.getParserController(ImmersiveKgParserCtrlType.TYPE_IMMERSIVE_KG);
    entry.immersiveKgData = immersiveKgParser?.parse(entry.request);
  }
}