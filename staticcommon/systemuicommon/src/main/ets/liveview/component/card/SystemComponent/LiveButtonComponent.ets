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

import { LiveViewData } from '../../../data/LiveViewData';
import { LiveButtonData } from '../../../data/extend/LiveButtonData';
import { LiveViewCommonConstants } from '../../../common/LiveConstants';
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { LiveViewSysEventUtil } from '../../../common/LiveViewSysEventUtil';
import { ExtendStyle } from '../../../common/Extendstyle';
import { ClickNotificationMaintenance } from '../../../../maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../../../maintenance/StatisticsConstants';

const TAG = LiveViewCommonConstants.LOG_PREFIX + 'LiveButtonComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export interface LiveButtonBuildParam {
  baseData?: LiveViewData;
  buttonData: LiveButtonData;
  extendStyle: ExtendStyle;
  isDarkMode: boolean;
  isNotBorder?: boolean;
  isCapsule?: boolean;
  bgBrightnessOption?: BrightnessOptions;
  isBrightnessDisable?: boolean;
  liveBtnNoBrightnessBgColor?: ResourceColor
}

@Builder
export function LiveButtonComponent($$: LiveButtonBuildParam) {
  Stack() {
    Column()
      .width($$.extendStyle.buttonLength)
      .height($$.extendStyle.buttonLength)
      .borderRadius($$.extendStyle.buttonBorderRadius)
      .visibility($$.isDarkMode ? Visibility.None : Visibility.Visible)
      .border({ width: $$.isNotBorder ? 0 : 1, color: $r('app.color.live_card_border_color') })
    Image($$.buttonData?.getButtonIcon())
      .syncLoad(true)
      .objectFit(ImageFit.Contain)
      .draggable(false)
      .autoResize(false)
      .interpolation(ImageInterpolation.Medium)
  }
  .id(`${TAG}_${$$.baseData?.creatorBundleName}_${$$.baseData?.id}_${$$.buttonData.name}`)
  .accessibilityLevel('no')
  .width($$.extendStyle.buttonHeight)
  .height($$.extendStyle.buttonHeight)
  .borderRadius($$.extendStyle.buttonBorderRadius)
  .clip(true)
  .opacity(1)
  .backgroundColor($$.isBrightnessDisable ? $$.liveBtnNoBrightnessBgColor : $$.extendStyle.buttonBackground)
  .backgroundBrightnessInternal(($$.isBrightnessDisable) ? undefined :
  $$.bgBrightnessOption)
  .onClick(() => onLiveButtonClick($$.buttonData, $$.baseData))
}

export function onLiveButtonClick(buttonData: LiveButtonData, baseData?: LiveViewData) {
  log.showInfo(`${TraceUtil.CORE_METHOD_CLICK_LIVE_WIN_BUTTON} start`);
  LiveViewSysEventUtil.reportLiveViewEvent(LiveViewSysEventUtil.CLICK_LIVE_WIN_BUTTON, {});
  ClickNotificationMaintenance.saveInfo({
    data: baseData,
    clickRegion: ClickRegion.LIVE_BUTTON,
    buttonName: buttonData?.name,
  });
  TraceUtil.startTrace(DomainName.SYS_UI, TraceUtil.CORE_METHOD_CLICK_LIVE_WIN_BUTTON);
  buttonData?.clickAction?.(buttonData, baseData);
  TraceUtil.endTrace(DomainName.SYS_UI, TraceUtil.CORE_METHOD_CLICK_LIVE_WIN_BUTTON);
  log.showInfo(`${TraceUtil.CORE_METHOD_CLICK_LIVE_WIN_BUTTON} end`);
}