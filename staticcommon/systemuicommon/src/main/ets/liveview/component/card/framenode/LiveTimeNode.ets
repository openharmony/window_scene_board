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
import { LiveViewCommonConstants } from '../../../common/LiveConstants';
import { immersiveKgMgr } from '../../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { fontScaleManager } from '@ohos/systemuiutils/src/main/ets/fontScale/fontScaleManager';
import { ColorModeViewModel } from '../../../../template/newStyle/ColorModeViewModel';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { NotificationType } from '../../../../constants/NotificationType';
import { LiveTimeParams } from './LiveTimeParams';
import { LiveAccessibilityUtil } from '../../../common/liveAccessibilityUtil';

const FONT_SCALE = 'font_scale';
const FONT_SCALE_DEFAULT = '1';

@Builder
export function LiveTimeNode($$: LiveTimeParams = new LiveTimeParams()) {
  if ($$?.timeData) {
    Text(getTimeText($$))
      .accessibilityText(getTimeAccessibilityText($$))
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .foregroundBrightness($$.isTitle ? undefined :
        ($$.aodStyle?.isAod ? undefined : ColorModeViewModel.getInstance().getViewData().foregroundSecondaryOption))
      .fontWeight(FontWeight.Medium)
      .fontSize(
        $$.timeTextStyle ?
        getChangeFontSize($$.timeTextStyle?.fontSize) :
          $$.isBigTextTimer ?
            ResUtils.getNumber($$.viewFontSize) + 'vp' :
          fontScaleManager.getSysFontScaleState().getScaleSize($$.viewFontSize)
      )
      .margin({
        bottom: $$.timeTextStyle?.marginBottom ?? $$.marginBottom,
      })
      .height($$.timeTextStyle?.height ?? 'auto')
      .id('live_view_component_node')
  }
}

function getTimeText(params: LiveTimeParams): string {
  if (immersiveKgMgr.getOneMirrorState().getAodStyle(
    params.notificationType === NotificationType.TYPE_PHONE_KEYGUARD)?.isAod && params.timeData?.isCountDown) {
    return LiveViewCommonConstants.AOD_COUNTDOWN_TEXT;
  }
  return LiveViewCommonConstants.formatDate(params.timeData?.initialTime, new Date(), params.timeData?.isCountDown);
}

function getTimeAccessibilityText(params: LiveTimeParams): string {
  if (immersiveKgMgr.getOneMirrorState().getAodStyle(
    params.notificationType === NotificationType.TYPE_PHONE_KEYGUARD)?.isAod && params.timeData?.isCountDown) {
    return LiveViewCommonConstants.AOD_COUNTDOWN_TEXT;
  }
  return LiveAccessibilityUtil.getTImeAccessibilityText(params.timeData);
}

function getChangeFontSize(fontSize: number | undefined): number | undefined {
  const fontScale = sSettingsUtil.getSystemValue(FONT_SCALE, FONT_SCALE_DEFAULT);
  if (fontSize && parseFloat(fontScale) > 1.15) {
    return (fontSize / parseFloat(fontScale)) * 1.15;
  }
  return fontSize;
}
