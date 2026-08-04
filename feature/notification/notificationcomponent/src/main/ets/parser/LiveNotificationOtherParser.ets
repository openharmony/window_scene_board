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
  LiveType,
  LogWithHa,
  NotificationAction,
  SystemUICommonUtil,
  SystemuiConstants,
  SysTypeCode,
} from '@ohos/systemuicommon';
import {
  LiveCardOtherModel,
  LiveCardProgressModel,
  LiveCardPickupModel,
  LiveCardFlightModel,
  LiveCardScoreModel,
  LiveCardNavigationModel,
  LiveRichTextModel,
  LiveExtensionType,
  LiveCapsuleType,
  LiveTimerModel,
  LiveCapsuleModel,
  LiveCapsuleTimerModel,
  LiveCapsuleProgressModel,
  LiveProgressModel,
  LiveCapsuleTextModel,
  LiveCapsuleRemindType,
  NotificationBase,
  NotificationUtil,
  LiveStatus,
  LiveCapsuleStatus,
  AppLifeCycleManager,
  LiveWeatherModel
} from '@ohos/systemuicommon/newTsIndex';
import { notificationSubscribe } from '@kit.NotificationKit';
import { image } from '@kit.ImageKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { FlightLayoutSpaceType, LayoutStyle } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';
import { OtherLiveViewInfo } from '../model/LiveViewContentModel';
import { LiveNotificationBaseParser } from './LiveNotificationBaseParser';
import { EventControl, LiveIndicatorType, LiveLineType } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCommonModel';
import { ImmDataHelper } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/immersivekg/helper/ImmDataHelper';
import {
  BackgroundType,
  LocationType,
  PriorityWeatherScene,
  PriorityWeatherType,
  WeatherType } from '@ohos/systemuicommon/src/main/ets/live/model/LiveWeatherModel';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { LiveExceptionCode } from '@ohos/systemuicommon/src/main/ets/live/constants/LiveExceptionCode';

const log = LogHelper.getLogHelper(LogDomain.NC, 'LiveNotificationOtherParser');

const HI_BOARD = 'com.ohos.intelligent';
const CHINA_RAIL = '12306';

/**
 * 三方实况卡片数据解析
 */
export class LiveNotificationOtherParser extends LiveNotificationBaseParser {
  private info: Record<string, Object> = {};

  constructor(postData: notificationSubscribe.SubscribeCallbackData, oldNtf?: NotificationBase) {
    super(postData, oldNtf);

    const liveView = postData.request.content.liveView;
    this.info.status = liveView?.status as number;
    this.info.lockscreenPicture = liveView?.lockscreenPicture!;
    if (liveView?.extraInfo) {
      SystemUICommonUtil.assign(this.info, liveView.extraInfo);
    }
    if (liveView?.pictureInfo) {
      SystemUICommonUtil.assign(this.info, liveView.pictureInfo);
    }
  }

  protected isHeadsUp(): boolean {
    if (this.request.deliveryTime && (Date.now() - this.request.deliveryTime) > SystemuiConstants.LIVE_TIME_DIFF) {
      log.showInfo(`no need show banner, date now ${Date.now()}, live deliveryTime ${this.request.deliveryTime}`);
      return false;
    }
    // Push云端推送的实况允许单独配置是否显示横幅
    if (this.request.agentBundle?.bundle === SystemuiConstants.PUSH_BUNDLE_NAME &&
      this.info['CapsuleData.remind'] === LiveCapsuleRemindType.EXPAND &&
      !AppLifeCycleManager.instance.isForeground(this.request.creatorUid)) {
      return true;
    }
    return false;
  }

  protected parseLiveViewCommonData(): void {
    super.parseLiveViewCommonData();
    this.ntf.typeCode = SysTypeCode.OTHER;
    // 判断是否是未安装元服务实况
    if (this.request?.extendInfo && this.request.extendInfo.autoServiceInstallStatus !== undefined) {
      this.ntf.isInstallMetaSer = this.request?.extendInfo.autoServiceInstallStatus ? true: false;
      // 获取该元服务包名
      this.ntf.unstallMetaSerBoundName = this.request?.extendInfo.appName ?? '';
    }
  }

  protected parseLiveViewExpandedData(): void {
    this.ntf.isEnd = this.isEnd();
  }

  protected getDuration(): number {
    return LiveNotificationBaseParser.DEFAULT_DURATION;
  }

  protected parseCardData(): LiveCardOtherModel {
    const layoutType = this.info['LayoutData.layoutType'] as LiveType;
    let cardData: LiveCardOtherModel;

    if (layoutType === LiveType.PROGRESS) {
      cardData = this.parseProgressCardData();
    } else if (layoutType === LiveType.PICK_UP) {
      cardData = this.parsePickupCardData();
    } else if (layoutType === LiveType.FLIGHT) {
      cardData = this.parseFlightCardData();
    } else if (layoutType === LiveType.SCORE) {
      cardData = this.parseScoreCardData();
    } else if (layoutType === LiveType.NAVIGATION) {
      cardData = this.parseNavigationCardData();
    } else if (layoutType === LiveType.NO_LAYOUT) {
      cardData = this.parseBaseCardData();
    } else {
      throw new Error('invalid layoutType: ' + layoutType);
    }

    if (cardData) {
      cardData.style = this.info['LayoutData.style'] as LayoutStyle;
      // 解析沉浸态数据
      this.parseImmersiveCardData(cardData);
    }

    return cardData;
  }

  protected parseCapsuleData(): LiveCapsuleModel | undefined {
    const capsuleType = this.info['CapsuleData.type'];
    let capsuleData: LiveCapsuleModel | undefined;

    if (capsuleType === LiveCapsuleType.TIMER) {
      capsuleData = new LiveCapsuleTimerModel();
      let capsuleTimerModel = capsuleData as LiveCapsuleTimerModel;
      capsuleTimerModel.timer = this.parseTimerData('TimerCapsule',
        this.oldNtf?.capsule?.isTimer() ? this.oldNtf?.capsule?.timer : undefined) ?? {} as LiveTimerModel;
      capsuleTimerModel.timer.presetTitle = this.info['LiveViewTimer.capsuleCountdownPreset.presetTitle'] as string ?? '';
      capsuleTimerModel.timer.presetContent = this.info['LiveViewTimer.capsuleCountdownPreset.presetContent'] as string ?? '';
      (capsuleData as LiveCapsuleTimerModel).content = this.info['TimerCapsule.content'] as string;
    } else if (capsuleType === LiveCapsuleType.PROGRESS) {
      capsuleData = new LiveCapsuleProgressModel();
      const progressData = new LiveProgressModel();
      progressData.maxValue = this.info['ProgressCapsule.max'] as number ?? 1;
      progressData.currentValue = this.info['ProgressCapsule.progress'] as number ?? 0;
      progressData.isPercentage = this.info['ProgressCapsule.indeterminate'] as boolean ?? false;
      (capsuleData as LiveCapsuleProgressModel).progress = progressData;
      (capsuleData as LiveCapsuleProgressModel).content = this.info['ProgressCapsule.content'] as string;
    } else if (capsuleType === LiveCapsuleType.TEXT) {
      capsuleData = new LiveCapsuleTextModel();
      (capsuleData as LiveCapsuleTextModel).title = this.info['TextCapsule.title'] as string;
      (capsuleData as LiveCapsuleTextModel).content = this.info['TextCapsule.content'] as string;
    }

    if (capsuleData) {
      capsuleData.backgroundColor = this.info['CapsuleData.backgroundColor'] as string;
      capsuleData.isContentDisplayed = this.info['CapsuleData.isContentDisplayed'] as boolean ?? true;
      // 强提醒更新需要记录更新时间，用于实况显示优先级排序
      if (this.ntf.remindConfig.isBannerEnable() || this.ntf.remindConfig.isCapsuleFlip()) {
        this.ntf.createTime = this.ntf.deliveryTime;
      }
      capsuleData.isTailIconDisplayed = this.info['CapsuleData.isTailIconDisplayed'] as boolean ?? false;
      if (capsuleData.isTailIconDisplayed) {
        this.setRawfileIcon('CapsuleData.tailIcon', (icons) => {
          if (capsuleData) {
            capsuleData.tailIcon = icons[0];
          }
        }, this.oldNtf?.capsule?.tailIcon)
      }
      this.setRawfileIcon('CapsuleData.icon', (icons) => {
        if (capsuleData) {
          capsuleData.icon = icons[0];
        }
      }, this.oldNtf?.capsule?.icon);
    }

    log.info(`other live capsule data parse end: ${this.ntf.hashCode}`, this.getCapsuleDataParseLog(capsuleData));
    return capsuleData;
  }

  protected parseRemindFlag(): void {
    // liveviewkit 上库后删除
    const type = this.info['CapsuleData.remind'] as LiveCapsuleRemindType;
    this.ntf.remindConfig.setCapsuleFlip(this.request.agentBundle?.bundle === SystemuiConstants.PUSH_BUNDLE_NAME &&
      type === LiveCapsuleRemindType.FLIP);
    this.ntf.remindConfig.setBanner(this.request.agentBundle?.bundle === SystemuiConstants.PUSH_BUNDLE_NAME &&
      type === LiveCapsuleRemindType.EXPAND);
  }

  private isEnd(): boolean {
    if (Date.now() > NotificationUtil.getOtherLiveTimeout(this.ntf) + this.ntf.deliveryTime) {
      log.showInfo(`Other live ${this.ntf.hashCode} is timeout`);
      return true;
    } else if (this.info.status === LiveStatus.END) {
      log.showInfo(`Other live ${this.ntf.hashCode} status is end`);
      return true;
    } else if (this.info['CapsuleData.status'] === LiveCapsuleStatus.HIDE) {
      log.showInfo(`Other live ${this.ntf.hashCode} capsule status is hide`);
      return true;
    }
    return false;
  }

  private isShowAuthorization(): boolean {
    if (this.slot && !this.ntf.isSettingIgnore) {
      return this.slot.authorizedStatus === 1;
    }
    return false;
  }

  /**
   * 解析实况基础卡片数据，即无扩展区的卡片数据
   * @param cardData 卡片数据
   * @returns 卡片数据
   */
  private parseBaseCardData(cardData: LiveCardOtherModel = new LiveCardOtherModel()): LiveCardOtherModel {
    cardData.event = this.info.event as string;
    cardData.fixedTitle = this.info['PrimaryData.title'] as string ?? '';
    cardData.fixedContent = LiveRichTextModel.parse(this.info['PrimaryData.content'] as string);
    if (this.info['LiveViewTimer.time'] !== undefined) {
      cardData.timer = this.parseTimerData('LiveViewTimer',
        this.oldNtf?.card?.isOtherCard() ? this.oldNtf.card.timer : undefined) ?? {} as LiveTimerModel;
      cardData.timer.presetTitle = this.info['LiveViewTimer.countdownPreset.presetTitle'] as string ?? '';
      cardData.timer.presetContent = this.info['LiveViewTimer.countdownPreset.presetContent'] as string ?? '';
    }
    // 实况授权显示不受更新影响
    cardData.isShowAuthorization = this.oldNtf?.card?.isOtherCard() ?
      this.oldNtf?.card?.isShowAuthorization : this.isShowAuthorization();
    cardData.isShowAuthorization = cardData.isShowAuthorization || (!this.ntf.isInstallMetaSer)
    this.parseExtendData(cardData);
    this.parseServiceButtonData(cardData);

    return cardData;
  }

  /**
   * 解析实况辅助区数据
   */
  private parseExtendData(cardData: LiveCardOtherModel): void {
    cardData.extensionType = this.info['ExtendData.type'] as LiveExtensionType ?? LiveExtensionType.DEFAULT;
    cardData.extensionText = this.info['ExtendData.text'] as string;
    cardData.extensionPicRes = this.info['ExtendData.pic.res'] as string;
    this.setRawfileIcon('ExtendData.pic', (icons) => {
      cardData.extensionPic = icons[0];
    }, this.oldNtf?.card?.isOtherCard() ? this.oldNtf?.card.extensionPic : undefined);
    // actionButtons第0位存放辅助区want
    if (this.request?.actionButtons?.length) {
      cardData.extensionWantAgent = this.request.actionButtons[0].wantAgent;
    }
    log.showWarn(`ExtendType: ${cardData.extensionType}, Text length: ${cardData.extensionText?.length}`);
  }

  /**
   * 解析实况关联服务按钮数据
   */
  private parseServiceButtonData(cardData: LiveCardOtherModel): void {
    const serviceButtonAuthLevel = SystemUICommonUtil.safeParseJson<EventControl>(
      this.info.eventControl as string)?.serviceButton ?? -1;
    if (serviceButtonAuthLevel === -1 || !serviceButtonAuthLevel) {
      log.showInfo('not show serviceButtons, serviceButtonAuthLevel is ' + serviceButtonAuthLevel);
      return;
    }
    const isServiceButtonsDisplayed = this.info['LayoutData.isServiceButtonsDisplayed'];
    if (!isServiceButtonsDisplayed) {
      log.showInfo('not show serviceButtons, isServiceButtonsDisplayed is ' + isServiceButtonsDisplayed);
      return;
    }
    log.showInfo(`serviceButton: ${serviceButtonAuthLevel} isServiceButtonsDisplayed: ${isServiceButtonsDisplayed} actionButtonLength: ${this.request?.actionButtons?.length}`);
    // actionButtons第1、2位存放关联服务按钮want，对应serviceButtons第0、1位
    if (this.request?.actionButtons?.length) {
      let i = this.request.actionButtons.length - 1;
      for (; i > 0; i--) {
        cardData.serviceButtons[i-1] = new NotificationAction({
          title: this.request.actionButtons[i]?.title,
          wantAgent: this.request.actionButtons[i]?.wantAgent,
        });
      }
    }
  }

  /**
   * 解析进度类片数据
   * @returns 卡片数据
   */
  private parseProgressCardData(): LiveCardProgressModel {
    const cardData = new LiveCardProgressModel();

    this.parseBaseCardData(cardData);
    cardData.layoutProgress = this.info['ProgressLayout.progress'] as number;
    cardData.layoutColor = this.info['ProgressLayout.color'] as string;
    cardData.layoutBackgroundColor = this.info['ProgressLayout.backgroundColor'] as string;
    cardData.layoutIndicatorType = this.info['ProgressLayout.indicatorType'] as LiveIndicatorType;
    cardData.layoutLineType = this.info['ProgressLayout.lineType'] as LiveLineType;
    this.setRawfileIcon('ProgressLayout.indicatorIcon', (icons) => {
      cardData.layoutIndicatorIcon = icons[0];
    }, this.oldNtf?.card?.isProgressCard() ? this.oldNtf.card.layoutIndicatorIcon : undefined);
    this.setRawfileIcon('ProgressLayout.nodeIcons', (icons) => {
      cardData.layoutNodeIcons = icons;
    }, this.oldNtf?.card?.isProgressCard() ? this.oldNtf.card.layoutNodeIcons : undefined);

    log.showInfo('parse:' + cardData.toString());
    return cardData;
  }

  /**
   * 解析取餐模板卡片数据
   * @returns 卡片数据
   */
  private parsePickupCardData(): LiveCardPickupModel {
    const cardData = new LiveCardPickupModel();

    this.parseBaseCardData(cardData);
    cardData.layoutTitle = this.info['PickupLayout.title'] as string;
    cardData.layoutContent = this.info['PickupLayout.content'] as string;
    cardData.layoutUnderlineColor = this.info['PickupLayout.underlineColor'] as string;
    cardData.layoutProviderName = this.info['PrimaryData.providerName'] as string;
    this.setRawfileIcon('PickupLayout.descPic', (icons) => {
      cardData.layoutDescPic = icons[0]!;
    }, this.oldNtf?.card?.isPickupCard() ? this.oldNtf.card.layoutDescPic : undefined);

    return cardData;
  }

  /**
   * 解析航班模板卡片数据
   * @returns 卡片数据
   */
  private parseFlightCardData(): LiveCardFlightModel {
    const cardData = new LiveCardFlightModel();

    this.parseBaseCardData(cardData);
    cardData.layoutFirstTitle = this.info['FlightLayout.firstTitle'] as string;
    cardData.layoutFirstContent = this.info['FlightLayout.firstContent'] as string;
    cardData.layoutLastTitle = this.info['FlightLayout.lastTitle'] as string;
    cardData.layoutLastContent = this.info['FlightLayout.lastContent'] as string;
    cardData.layoutLastTitleSuperscript = this.info['FlightLayout.lastTitleSuperscript'] as string;
    cardData.layoutLastContentSuperscript = this.info['FlightLayout.lastContentSuperscript'] as string;
    cardData.layoutIsDisplayHorizontalLine = this.info['FlightLayout.isDisplayHorizontalLine'] as boolean ?? true;
    cardData.layoutAdditionalText = this.info['FlightLayout.additionalText'] as string;
    cardData.layoutSpaceType = this.info['FlightLayout.spaceType'] as FlightLayoutSpaceType;
    cardData.layoutSpaceText = this.info['FlightLayout.spaceText'] as string;
    cardData.layoutSpaceIconRes = this.info['FlightLayout.spaceIcon.res'] as string;
    this.parseWeatherInfo(cardData);
    this.setRawfileIcon('FlightLayout.spaceIcon', (icons) => {
      cardData.layoutSpaceIcon = icons[0]!;
      if (this.ntf?.creatorBundleName === HI_BOARD && cardData?.isFlightCard() &&
        cardData.layoutAdditionalText?.includes(CHINA_RAIL)) {
        if (cardData.layoutSpaceIcon) {
          this.ntf.appIcon = cardData.layoutSpaceIcon;
          this.ntf.useCustomAppIcon = true;
        } else {
          log.showInfo('HI_BOARD: space icon is invalid');
        }
      }
    }, this.oldNtf?.card?.isFlightCard() ? this.oldNtf.card.layoutSpaceIcon : undefined);

    return cardData;
  }

  private parseWeatherInfo(cardData: LiveCardFlightModel): void {
    try {
      let weather = new LiveWeatherModel();
      weather.highTemperature = this.info['WeatherInfo.highTemperature'] as number;
      weather.lowTemperature = this.info['WeatherInfo.lowTemperature'] as number;
      weather.weatherType = this.info['WeatherInfo.weatherType'] as WeatherType;
      weather.locationType = this.info['WeatherInfo.locationType'] as LocationType;
      weather.backgroundType = this.info['PrimaryData.backgroundType'] as BackgroundType;
      weather.isWeatherCapsuleShow = this.checkWeatherInfo(weather);
      weather.showType = this.checkShowWeatherScene(weather);
      weather.isUpdateAnimation = this.checkLiveWeatherAnimationUpdate(weather);
      cardData.liveCardWeatherInfo = weather;
      log.showInfo(`weather info is ${weather.highTemperature}, ${weather.lowTemperature}, ${weather.weatherType}, ${weather.locationType}, ${weather.backgroundType}`);
    } catch (e) {
      log.showError(`get weather info error ${e}`);
    }
  }

  /**
   * 解析比分模板卡片数据
   * @returns 卡片数据
   */
  private parseScoreCardData(): LiveCardScoreModel {
    const cardData = new LiveCardScoreModel();

    this.parseBaseCardData(cardData);
    cardData.layoutHostName = this.info['ScoreLayout.hostName'] as string;
    cardData.layoutHostScore = this.info['ScoreLayout.hostScore'] as string;
    this.setRawfileIcon('ScoreLayout.hostIcon', (icons) => {
      cardData.layoutHostIcon = icons[0];
    }, this.oldNtf?.card?.isScoreCard() ? this.oldNtf.card.layoutHostIcon : undefined);
    cardData.layoutGuestName = this.info['ScoreLayout.guestName'] as string;
    cardData.layoutGuestScore = this.info['ScoreLayout.guestScore'] as string;
    this.setRawfileIcon('ScoreLayout.guestIcon', (icons) => {
      cardData.layoutGuestIcon = icons[0];
    }, this.oldNtf?.card?.isScoreCard() ? this.oldNtf.card.layoutGuestIcon : undefined);
    cardData.layoutCompetitionDesc = LiveRichTextModel.parse(this.info['ScoreLayout.competitionDesc'] as string);
    cardData.layoutCompetitionTime = this.info['ScoreLayout.competitionTime'] as string;
    cardData.layoutIsDisplayHorizontalLine = this.info['ScoreLayout.isDisplayHorizontalLine'] as boolean ?? true;

    return cardData;
  }

  /**
   * 解析导航模板卡片数据
   * @returns 卡片数据
   */
  private parseNavigationCardData(): LiveCardNavigationModel {
    const cardData = new LiveCardNavigationModel();

    this.parseBaseCardData(cardData);
    this.setRawfileIcon('NavigationLayout.currentNavigationIcon', (icons) => {
      cardData.layoutCurrentNavigationIcon = icons[0];
    }, this.oldNtf?.card?.isNavigationCard() ? this.oldNtf.card.layoutCurrentNavigationIcon : undefined);
    this.setRawfileIcon('NavigationLayout.navigationIcons', (icons) => {
      cardData.layoutNavigationIcons = icons;
    }, this.oldNtf?.card?.isNavigationCard() ? this.oldNtf.card.layoutNavigationIcons : undefined);
    cardData.layoutIsNavigationIconsDisplayed = this.info['NavigationLayout.isNavigationIconsDisplayed'] as boolean ?? true;
    cardData.layoutIsDisplayHorizontalLine = this.info['NavigationLayout.isDisplayHorizontalLine'] as boolean ?? true;
    cardData.layoutNavigationIconMimeType = this.getIconMimeType('NavigationLayout.currentNavigationIcon',
      cardData.layoutCurrentNavigationIcon);
    return cardData;
  }

  /**
   * 解析沉浸大图数据，填充三方模板
   *
   * @param cardData 卡片数据
   */
  private parseImmersiveCardData(cardData: LiveCardOtherModel): void {
    // 直接携带大图
    if (this.info.lockscreenPicture) {
      cardData.immersivePic = this.info.lockscreenPicture as image.PixelMap;
      log.showInfo('parseImmersiveCardData pic pixel: true');
    }
    // res大图优先级高，允许进行覆盖
    this.setRawfileIcon('PrimaryData.immersivePic', (icons) => {
      if (icons[0]) {
        cardData.immersivePic = icons[0];
      }
      if (cardData.immersivePic) {
        log.showInfo('parseImmersiveCardData pic res: true');
      }
    }, this.oldNtf?.card?.isOtherCard() ? this.oldNtf.card.immersivePic : cardData.immersivePic);
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
    cardData.immersiveCardAuthLevel = lockScreenVal;
    // UIExtension检测
    let bundleName = this.ntf.creatorBundleName;
    let liveId = this.ntf.id;
    let immAbilityName = this.info['PrimaryData.immersiveAbilityName'] as string;
    let immParameters = (this.info['PrimaryData.immersiveParameters'] ?? {}) as Record<string, Object>;
    if (ImmDataHelper.getInstance().checkUIExtensionValid(bundleName, immAbilityName)) {
      immParameters.id = liveId;
      // UIExtension检测通过的沉浸大卡数据，没有设置权益值则默认允许进沉浸态
      cardData.immersiveCardAuthLevel = cardData.immersiveCardAuthLevel === -1 ? 1 : cardData.immersiveCardAuthLevel;
      // 标示沉浸类型
      immParameters['ability.want.params.uiExtensionType'] = ImmDataHelper.EXT_ABILITY_TYPE_IMMERSIVE;
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
  }

  /**
   * 设置rawfile图片
   * @param iconKey 图片字段名，如果通过该字段
   * @param callback 图片回调
   * @param oldIcons 旧实况通知的图片
   */
  private setRawfileIcon(iconKey: keyof OtherLiveViewInfo,
    callback: (icon: image.PixelMap[]) => void,
    oldIcons?: image.PixelMap | image.PixelMap[]
  ): void {
    const updateKeys = this.info.ExtraInfoUpdateKey as string[];
    const iconResKey = iconKey + '.res';
    log.showInfo(`Set rawfile icon for ${iconKey}, ExtraInfoUpdateKey: ${updateKeys}`);
    if (oldIcons && updateKeys?.length && !updateKeys.includes(iconKey) &&
      !updateKeys.includes(iconResKey)) {
      log.showWarn(`No need update rawfile icon for ${iconKey}`);
      callback(oldIcons ? this.getIconArray(oldIcons) : []);
      return;
    }

    const icons = this.info[iconKey] as image.PixelMap[];
    const iconRes = this.info[iconResKey] as string | string[];
    const res: string[] = typeof iconRes === 'string' && iconRes ? [iconRes] : iconRes as string[];
    const canParseByCache = res && res.length && oldIcons && res.length === this.getIconArray(oldIcons).length;
    const isSameVersion = this.ntf.appVersionName === this.oldNtf?.appVersionName;
    const isNavigation = this.info['LayoutData.layoutType'] === LiveType.NAVIGATION;

    log.showInfo(`Set rawfile icon for ${iconKey}, icon.length: ${icons?.length}, res: ${res}`);
    // 是否为协同场景，协同场景仅传入pixelMap,res仅用于导航赋色后缀
    const isCollaNotification = this.request.extendInfo?.notification_collaboration_flag;
    // 图片数相同时优化更新流程
    if (canParseByCache && isSameVersion && isNavigation && !isCollaNotification) {
      log.showInfo(`start handleIconParseByCache for ${iconKey}, ${res.length}`);
      this.handleIconParseByCache(res, iconKey, oldIcons, callback);
      return;
    }

    if (Array.isArray(res) && res.length && !isCollaNotification) {
      this.bundleResourceParser.addRawfileImage(res, callback);
    } else if (icons?.length) {
      icons.forEach((icon) => {
        SystemUICommonUtil.setPixelMapName(icon, `${this.ntf.hashCode}_pixelMap_${iconKey}`);
      });
      callback(icons);
    } else {
      log.showWarn(`No icon for ${iconKey}`);
    }
  }

  private getIconArray(icons: image.PixelMap | image.PixelMap[]): image.PixelMap[] {
    return Array.isArray(icons) ? icons : [icons];
  }

  private getIconArrayInfo(icons: (image.PixelMap | undefined)[]) {
    return icons.map((pix) => SystemUICommonUtil.getPixelMapName(pix));
  }

  private handleIconParseByCache(
    res: string[],
    iconKey: string,
    oldIcons: image.PixelMap | image.PixelMap[],
    callback: (icon: image.PixelMap[]) => void): void {
    const result: (image.PixelMap | undefined)[] = [];
    const parse: string[] = [];

    res.forEach((url: string, index: number) => {
      const icon = this.getIconArray(oldIcons)[index];
      const name = `${this.ntf.hashCode}_rawfile_${url}`;

      if (SystemUICommonUtil.getPixelMapName(icon) === name) {
        result.push(icon);
      } else {
        result.push(undefined);
        parse.push(url);
      }
    });
    log.showInfo(`generate result success, result: ${this.getIconArrayInfo(result)}, parse: ${parse}`);

    // 存在新路径的图片则将新的图片进行解析
    if (parse.length) {
      const innerCallback: (icons: image.PixelMap[]) => void = (icons: image.PixelMap[]) => {
        icons.forEach((icon) => {
          const index = result.findIndex((e) => e === undefined);
          result.splice(index, 1, icon);
        });

        log.showInfo(`parse icon for ${iconKey} success: ${this.getIconArrayInfo(result)}`);
        callback(result as image.PixelMap[]);
      }

      this.bundleResourceParser.addRawfileImage(parse, innerCallback);
      return;
    }

    // 不存在新路径的图片 全部复用旧的图片
    log.showWarn(`No image url changed.`);
    callback(result as image.PixelMap[]);
  }

  /**
   * 解析计时器数据
   * @param timerKeyPrefix 计时器数据的key前缀，如TimerCapsule、LiveViewTimer
   * @returns
   */
  private parseTimerData(timerKeyPrefix: string, oldTimer?: LiveTimerModel): LiveTimerModel | undefined {
    let timer: LiveTimerModel;

    // isUpdateTimer为false表示initialTime未改变不需要更新计时器，使用上一次的计时器对象
    log.showInfo(`Other timer ${timerKeyPrefix}.isUpdateTimer:` + this.info[`${timerKeyPrefix}.isUpdateTimer`]);
    if (oldTimer && !this.info[`${timerKeyPrefix}.isUpdateTimer`]) {
      timer = oldTimer;
      timer.isUpdateTimer = false;
    } else {
      timer = new LiveTimerModel(`${timerKeyPrefix}_${this.request.hashCode}`);
      timer.initialTime = this.info[`${timerKeyPrefix}.time`] as number ?? 0;
    }
    timer.requestInitialTime = this.info[`${timerKeyPrefix}.time`] as number;
    timer.isPaused = this.info[`${timerKeyPrefix}.isPause`] as boolean ??
      this.info[`${timerKeyPrefix}.isPaused`] as boolean ?? false;
    timer.isCountdown = this.info[`${timerKeyPrefix}.isCountdown`] as boolean ?? false;
    log.info('Other timer:', timer);
    return timer;
  }

  private getCapsuleDataParseLog(capsuleData: LiveCapsuleModel | undefined): Record<string, Object> {
    const result: Record<string, Object> = {};
    result.backgroundColor = capsuleData?.backgroundColor as string;
    result.type = capsuleData?.getCapsuleType() as LiveCapsuleType;
    result.isExpand = this.ntf.isExpand();
    result.isFlip = this.ntf.isFlip();
    result.isTailIconDisplayed = Boolean(capsuleData?.isTailIconDisplayed);
    return result;
  }

  private getIconMimeType(iconKey: keyof OtherLiveViewInfo, pixelMap?: image.PixelMap): string {
    const iconResKey = iconKey + '.res';
    const res = this.info[iconResKey] as string;
    // 如果带有相应的key, 则直接用key值判断
    if (res) {
      return res.substring(res.length - 3, res.length);
    }

    // 直接使用图片的mimeType
    const mimeType = pixelMap?.getImageInfoSync()?.mimeType ?? '';
    return mimeType === 'image/svg+xml' ? 'svg' : (mimeType === 'image/png' ? 'png' : '');
  }

  private checkWeatherInfo(weatherInfo?: LiveWeatherModel): boolean {
    if (!SystemUICcmConfig.instance.isEnabledLive2) {
      return false;
    }
    if (!weatherInfo) {
      log.showInfo(`weatherInfo invalid: ${weatherInfo}`);
      return false;
    }
    if (weatherInfo.highTemperature === undefined || weatherInfo.lowTemperature === undefined ||
      !weatherInfo.weatherType || weatherInfo.locationType !== LocationType.LOCATION_TYPE_DESTINATION) {
      log.showInfo(`weather info invalid, ${weatherInfo.highTemperature}, ${weatherInfo.lowTemperature}, ${weatherInfo.weatherType}, ${weatherInfo.locationType}`);
      return false;
    }
    if (weatherInfo.highTemperature > 58 || weatherInfo.lowTemperature < -95) {
      LogWithHa.warn(log,
        `temperature info invalid, highTemperature ${weatherInfo.highTemperature}, ${weatherInfo.lowTemperature}`,
        LiveExceptionCode.WEATHER_TEMPERATURE_RANGE_INVALID);
      return false;
    }
    if (weatherInfo.highTemperature <= weatherInfo.lowTemperature) {
      LogWithHa.warn(log,
        `lowtemperature >= highTemperature ${weatherInfo.highTemperature}, ${weatherInfo.lowTemperature}`,
        LiveExceptionCode.WEATHER_HIGH_TEMPERATURE_LOWER_THAN_LOW_TEMPERATURE_INVALID);
      return false;
    }
    if (!Object.values(WeatherType).includes(weatherInfo.weatherType)) {
      LogWithHa.warn(log, `weatherType not in enum: ${weatherInfo.weatherType}`,
        LiveExceptionCode.WEATHER_TYPE_INVALID);
      return false;
    }
    if (!Object.values(LocationType).includes(weatherInfo.locationType)) {
      log.showInfo(`LocationType not in enum: ${weatherInfo.locationType}`);
      return false;
    }
    return true;
  }

  private checkShowWeatherScene(weatherInfo?: LiveWeatherModel): PriorityWeatherScene {
    if (!SystemUICcmConfig.instance.isEnabledLive2) {
      return PriorityWeatherScene.INVALID_SCENE;
    }
    const checkResult = this.checkWeatherInfo(weatherInfo);
    if (!checkResult && !weatherInfo?.backgroundType) {
      return PriorityWeatherScene.INVALID_SCENE;
    }
    if (checkResult) {
      const weather = (weatherInfo?.weatherType) as number;
      if (Object.values(PriorityWeatherType).includes(weather)) {
        return PriorityWeatherScene.WEATHER_SCENE;
      }
      if (!Object.values(PriorityWeatherType).includes(weather) && weatherInfo?.backgroundType) {
        return this.getBackgroundScene(weatherInfo?.backgroundType);
      }
    }
    if (!checkResult && weatherInfo?.backgroundType) {
      return this.getBackgroundScene(weatherInfo?.backgroundType);
    }
    return PriorityWeatherScene.INVALID_SCENE;
  }

  private getBackgroundScene(backgroundType?: BackgroundType): PriorityWeatherScene {
    if (!backgroundType) {
      return PriorityWeatherScene.INVALID_SCENE;
    }
    if (backgroundType === BackgroundType.SYS_BACKGROUND_FLIGHT_MOON) {
      return PriorityWeatherScene.MOON_SCENE;
    }
    if (backgroundType === BackgroundType.SYS_BACKGROUND_FLIGHT_SUNSET) {
      return PriorityWeatherScene.SUNSET_SCENE;
    }
    return PriorityWeatherScene.INVALID_SCENE;
  }

  private checkLiveWeatherAnimationUpdate(weather: LiveWeatherModel): boolean {
    if (!this.oldNtf) {
      return false;
    }
    if (!this.oldNtf.card.isFlightCard()) {
      return true;
    }
    const oldWeatherType = this.oldNtf.card.liveCardWeatherInfo?.weatherType;
    const oldBackgroundType = this.oldNtf.card.liveCardWeatherInfo?.backgroundType;
    log.showInfo(`oldInfo: ${oldWeatherType}-${oldBackgroundType}`);
    if (oldWeatherType !== weather.weatherType || oldBackgroundType !== weather.backgroundType) {
      return true;
    }
    return false;
  }
}