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

import { LiveCapsuleRemindType, LiveCapsuleStatus, LiveCapsuleType,
  LiveExtensionType, LiveIndicatorType, LiveLineType, LiveStatus } from '@ohos/systemuicommon/newTsIndex';
import { LiveType } from '@ohos/systemuicommon';
import { image } from '@kit.ImageKit';
import {
  BackgroundType,
  LocationType, WeatherType } from '@ohos/systemuicommon/src/main/ets/live/model/LiveWeatherModel';

/**
 * 三方实况字段列表
 */
export interface OtherLiveViewInfo {
  /**
   * 三方实况类型
   */
  'LayoutData.layoutType': LiveType;
  /**
   * 关联服务按钮数组
   */
  'LayoutData.serviceButtons'?: string[];
  /**
   * 是否显示关联服务按钮
   */
  'LayoutData.isServiceButtonsDisplayed'?: boolean;
  /**
   * 权益信息
   */
  eventControl?: string;
  /**
   * 实况场景
   */
  event: string;
  /**
   * 是否静默提醒，默认静默提醒
   */
  isMute?: boolean;
  /**
   * 实况数据状态
   */
  status: LiveStatus;
  /**
   * 实况数据更新时变化的字段列表
   */
  ExtraInfoUpdateKey: string[];

  /**
   * 胶囊类型
   */
  'CapsuleData.type': LiveCapsuleType;
  /**
   * 胶囊状态
   */
  'CapsuleData.status'?: LiveCapsuleStatus;
  /**
   * 胶囊图标
   */
  'CapsuleData.icon'?: image.PixelMap[];
  /**
   * 胶囊副文本图标
   */
  'CapsuleData.tailIcon'?: image.PixelMap[];
  /**
   * 胶囊背景色
   */
  'CapsuleData.backgroundColor'?: string;
  /**
   * 胶囊提醒方式
   */
  'CapsuleData.remind'?: LiveCapsuleRemindType;
  /**
   * 胶囊图标资源
   */
  'CapsuleData.icon.res'?: string;
  /**
   * 胶囊内容是否显示
   */
  'CapsuleData.isContentDisplayed'?: boolean;
  /**
   * 文本类型胶囊标题
   */
  'TextCapsule.title'?: string;
  /**
   * 文本胶囊类型内容
   */
  'TextCapsule.content'?: string;
  /**
   * 进度胶囊最大值
   */
  'ProgressCapsule.max'?: number;
  /**
   * 进度胶囊当前值
   */
  'ProgressCapsule.progress'?: number;
  /**
   * 是否显示为百分比
   */
  'ProgressCapsule.indeterminate'?: boolean;
  /**
   * 计时器胶囊时间
   */
  'TimerCapsule.time'?: number;
  /**
   * 计时器胶囊是否为倒计时
   */
  'TimerCapsule.isCountdown'?: boolean;
  /**
   * 计时器胶囊是否暂停
   */
  'TimerCapsule.isPause'?: boolean;
  /**
   * 计时器胶囊内容
   */
  'TimerCapsule.content'?: string;
  /**
   * 计时器胶囊本次是否更新
   */
  'TimerCapsule.isUpdateTimer'?: boolean;

  /**
   * 固定区标题
   */
  'PrimaryData.title': string;
  /**
   * 固定区内容
   */
  'PrimaryData.content': string;
  /**
   * 服务提供商名称
   */
  'PrimaryData.providerName'?: string;

  /**
   * 扩展区类型
   */
  'ExtendData.type': LiveExtensionType;
  /**
   * 扩展区文本
   */
  'ExtendData.text'?: string;
  /**
   * 扩展区图标
   */
  'ExtendData.pic'?: [image.PixelMap];
  /**
   * 扩展区图标资源rawfile路径
   */
  'ExtendData.pic.res'?: string;

  /**
   * 计时器初始时间
   */
  'LiveViewTimer.time'?: number;
  /**
   * 是否需要更新计时器初始时间
   */
  'LiveViewTimer.isUpdateTimer'?: boolean;
  /**
   * 计时器是否为倒计时
   */
  'LiveViewTimer.isCountdown'?: boolean;
  /**
   * 计时器是否暂停
   */
  'LiveViewTimer.isPaused'?: boolean;
  /**
   * 自动更新预置标题
   */
  'LiveViewTimer.countdownPreset.presetTitle'?: string;
  /**
   * 自动更新预置内容
   */
  'LiveViewTimer.countdownPreset.presetContent'?: string;
  /**
   * 自动更新预置胶囊标题
   */
  'LiveViewTimer.capsuleCountdownPreset.presetTitle'?: string;
  /**
   * 自动更新预置胶囊内容
   */
  'LiveViewTimer.capsuleCountdownPreset.presetContent'?: string;

  /**
   * 进度百分比，范围[0,100]
   */
  'ProgressLayout.progress'?: number;
  /**
   * 进度条颜色
   */
  'ProgressLayout.color'?: string;
  /**
   * 进度条背景颜色
   */
  'ProgressLayout.backgroundColor'?: string;
  /**
   * 扩展区指示器小图标显示类型
   */
  'ProgressLayout.indicatorType'?: LiveIndicatorType;
  /**
   * 进度条指示器图标
   */
  'ProgressLayout.indicatorIcon'?: [image.PixelMap];
  /**
   * 进度条指示器图标资源rawfile路径
   */
  'ProgressLayout.indicatorIcon.res'?: string;
  /**
   * 扩展区进度条显示类型
   */
  'ProgressLayout.lineType'?: LiveLineType;
  /**
   * 进度条每个节点图标，数组长度范围为[2, 5]
   */
  'ProgressLayout.nodeIcons'?: image.PixelMap[];
  /**
   * 进度条每个节点图标资源rawfile路径
   */
  'ProgressLayout.nodeIcons.res'?: string[];

  /**
   * 扩展区标题
   */
  'PickupLayout.title'?: string;
  /**
   * 扩展区内容
   */
  'PickupLayout.content'?: string;
  /**
   * 扩展区内容下划线颜色
   */
  'PickupLayout.underlineColor'?: string;
  /**
   * 扩展区右侧产品描述图
   */
  'PickupLayout.descPic'?: [image.PixelMap];
  /**
   * 扩展区右侧产品描述图资源rawfile
   */
  'PickupLayout.descPic.res'?: string;

  /**
   * 扩展区左侧标题
   */
  'FlightLayout.firstTitle'?: string;
  /**
   * 扩展区左侧内容
   */
  'FlightLayout.firstContent'?: string;
  /**
   * 扩展区右侧标题
   */
  'FlightLayout.lastTitle'?: string;
  /**
   * 扩展区右侧内容
   */
  'FlightLayout.lastContent'?: string;
  /**
   * 扩展区中间间隔图标
   */
  'FlightLayout.spaceIcon'?: [image.PixelMap];
  /**
   * 扩展区中间间隔图标资源rawfile
   */
  'FlightLayout.spaceIcon.res'?: string;
  /**
   * 是否显示扩展区分割线
   */
  'FlightLayout.isDisplayHorizontalLine'?: boolean;
  /**
   * 扩展区底部内容
   */
  'FlightLayout.additionalText'?: string;

  /**
   * 扩展区左侧名称
   */
  'ScoreLayout.hostName'?: string;
  /**
   * 扩展区左侧图标
   */
  'ScoreLayout.hostIcon'?: [image.PixelMap];
  /**
   * 扩展区左侧图标资源rawfile
   */
  'ScoreLayout.hostIcon.res'?: string;
  /**
   * 扩展区左侧比分
   */
  'ScoreLayout.hostScore'?: string;
  /**
   * 扩展区右侧名称
   */
  'ScoreLayout.guestName'?: string;
  /**
   * 扩展区右侧图标
   */
  'ScoreLayout.guestIcon'?: [image.PixelMap];
  /**
   * 扩展区右侧图标资源rawfile
   */
  'ScoreLayout.guestIcon.res'?: string;
  /**
   * 扩展区右侧比分
   */
  'ScoreLayout.guestScore'?: string;
  /**
   * 扩展区中间上方描述文本，比赛介绍
   */
  'ScoreLayout.competitionDesc'?: string;
  /**
   * 扩展区中间下方比赛时间
   */
  'ScoreLayout.competitionTime'?: string;
  /**
   * 是否显示扩展区分割线
   */
  'ScoreLayout.isDisplayHorizontalLine'?: boolean;

  /**
   * 当前导航方向
   */
  'NavigationLayout.currentNavigationIcon'?: [image.PixelMap];
  /**
   * 当前导航方向资源rawfile
   */
  'NavigationLayout.currentNavigationIcon.res'?: string;
  /**
   * 导航方向的箭头集合图片，支持1-11个
   */
  'NavigationLayout.navigationIcons'?: image.PixelMap[];
  /**
   * 导航方向的箭头集合图片资源rawfile，支持1-11个
   */
  'NavigationLayout.navigationIcons.res'?: string[];
  /**
   * 导航方向的箭头集合图片是否显示
   */
  'NavigationLayout.isNavigationIconsDisplayed'?: boolean;
  /**
   * 是否显示扩展区分割线
   */
  'NavigationLayout.isDisplayHorizontalLine'?: boolean;

  /**
   * 锁屏时沉浸大图
   */
  lockscreenPicture?: image.PixelMap;

  /**
   * 锁屏时沉浸大图
   */
  'PrimaryData.immersivePic'?: image.PixelMap;

  /**
   * 锁屏时沉浸大图资源rawfile
   */
  'PrimaryData.immersivePic.res'?: string;

  /**
   * 锁屏时沉浸卡片UIExtension的目标页面
   */
  'PrimaryData.immersiveAbilityName'?: string;

  /**
   * 锁屏时沉浸卡片UIExtension的扩展参数
   */
  'PrimaryData.immersiveParameters'?: Record<string, Object>;
  /**
   * 天气高温
   */
  'WeatherInfo.highTemperature'?: number;
  /**
   * 天气低温
   */
  'WeatherInfo.lowTemperature'?: number;
  /**
   * 天气类型
   */
  'WeatherInfo.weatherType'?: WeatherType;
  /**
   * 航班地类型
   */
  'WeatherInfo.locationType'?: LocationType;
  /**
   * 航班卡片背景类型
   */
  'PrimaryData.backgroundType'?: BackgroundType;
}