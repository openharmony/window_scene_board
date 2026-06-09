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
import { LengthMetrics } from '@kit.ArkUI';
import { ExtAppConstants } from '@ohos/commonconstants';
import { DeviceState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { DropDownPanelConstants } from '@ohos/systemuicommon/Index';
import { NotificationConfig } from '../../common/NotificationConfig';

type onSafePaddingChange = (safePadding: LengthMetrics) => void;

type onContainerMarginTopChangeSet = (containerMarginTop?: number) => void;

type onOuterHeightOfNCAndCCChangeSet = (outerHeightOfNCAndCC: Length) => void;

type onClearBtnBottomPaddingChangeSet = (clearBtnBottomPadding: LengthMetrics) => void;

type onIsShowNtfPanelHeaderChangeSet = (isShowNtfPanelHeader: boolean) => void;

type onIsScreenLockChangeSet = (isScreenLock: boolean) => void;

type onIsFilterNtfAfterScreenLockChange = (isFilterNtfAfterScreenLock: boolean) => void;

type onDropDownPanelDistanceChange = (dropDownPanelDistance: number) => void;

export enum NtfBrightnessMode {
  // 卡片组件单独设置提亮属性。
  Distributed = 0,
  // 在模糊合并组件上面集中设置提亮属性。
  Centralized = 1,
}

export class NtfListContentConfig {
  // “更多通知”收起卡片，转场动效参数
  public extraBriefTransitionEffect: TransitionEffect = TransitionEffect.asymmetric(
    TransitionEffect.OPACITY.animation({ duration: 183 }),
    TransitionEffect.OPACITY.animation({ delay: 100, duration: 183 }));

  // “更多通知”组件间转场动效参数
  public extraGeometryTransitionId?: string;

  public clipParam: boolean = true;

  public pinTopUseSymbolGlyph: boolean = false;

  //renderGroup组件开关
  public renderGroupSwitch: boolean = true;

  public isOuterHome: boolean = false;

  public isSupportFloating: boolean = true;

  public isRefreshStatusBarIconDelay: boolean = false; // 横幅消失后刷新状态栏图标

  public safePadding: LengthMetrics = LengthMetrics.resource($r('app.float.ntf_item_padding_start_end'));

  public safePaddingChangedSet = new Set<onSafePaddingChange>();

  public containerMarginTop?: number = undefined;

  public containerMarginTopChangeSet = new Set<onContainerMarginTopChangeSet>();

  // 提亮模式
  public brightnessMode: NtfBrightnessMode = NtfBrightnessMode.Distributed;
  // 一键删除时通知卡片动效计算参数
  public clearAllAnimationDelayParam = 250;
  // 通知中心卡片列表头尾卡片是否有内折效果
  public isNtfListFold = true;
  // 通知中心高度默认值 = 屏幕高度 - 状态栏高度
  public ntfListDefaultHeight: string = `100%`;
  // 扩展新形态小折叠产品的外屏双中心的高度适配
  public outerHeightOfNCAndCC: Length = this.ntfListDefaultHeight;
  public outerHeightOfNCAndCCChangeSet = new Set<onOuterHeightOfNCAndCCChangeSet>();
  // 一键删除按钮的底边距
  public clearBtnBottomPadding: LengthMetrics = LengthMetrics.resource($r('app.float.ntf_clear_btn_padding'));
  public clearBtnBottomPaddingChangeSet = new Set<onClearBtnBottomPaddingChangeSet>();
  // 是否展示NC的时间与日期
  public isShowNtfPanelHeader: boolean = true;
  public isShowNtfPanelHeaderChangeSet = new Set<onIsShowNtfPanelHeaderChangeSet>();
  // 是否锁屏
  public isScreenLock: boolean = false;
  public screenLockChangeSet = new Set<onIsScreenLockChangeSet>();
  // 上滑收起通知中心的阈值
  public dropDownPanelDistance: number = DropDownPanelConstants.DISTANCE_FOLD_NOTIFICATION_DROPDOWN;
  public dropDownPanelDistanceChangeSet = new Set<onDropDownPanelDistanceChange>();
  // 通知按钮个数
  public buttonMaxShowSize: number = 2;
  // 通知按钮是否支持回复
  public isSupportReplyButton: boolean = true;
  // 锁屏时间
  public screenLockTime: number = -1;

  // 是否过滤锁屏后来的通知
  public isFilterNtfAfterScreenLock: boolean = false;
  public isFilterNtfAfterScreenLockChangeSet = new Set<onIsFilterNtfAfterScreenLockChange>();
  // 更多设置按钮跳转
  public moreSettingModuleName: string = ExtAppConstants.MODULE_PHONE_SETTINGS_SOUND;
  public moreSettingUri: string = 'systemui_notification_settings';
  // 是否元服务通知管理和应用使用同一个页面
  public isMetaSettingSamePage: boolean = false;
  // 通知中心是否支持显示实况
  public isNtfPanelShowLiveType: boolean = true;
  // 通知跳转到通知管理是否携带icon
  public isNtfJumpWithIcon: boolean = true;
  // 通知列表缓存通知数量
  public cachedCount: number = NotificationConfig.LIST_CACHE_COUNT;
  // 通知跳转到应用是否直接跳转不带动效
  public isNtfStartDirectly: boolean = false;

  /**
   * 基于折叠屏显示模式变更受影响的配置参数
   * @param state 折叠状态
   */
  public changeFoldConfig(state: DeviceState): void {
  };
}
