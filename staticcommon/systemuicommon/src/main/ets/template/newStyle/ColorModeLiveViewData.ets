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
import { effectKit } from '@kit.ArkGraphics2D';
import { VisualEffectConstants } from '@ohos/commonconstants';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';

@Observed
export class ColorModeLiveViewData {
  /* 通知提亮禁用 */
  public isNtfBrightnessDisable =
    SCBVisualEffectMgr.getFeatureParam(VisualEffectConstants.NTF_BRIGHTENS_DISABLE) === 'true';

  // 纯色模式实况背景取色
  public livePickColor: effectKit.Color = {red: 255, green: 255, blue: 255, alpha: 255};
  public liveBgPickColor: effectKit.Color = {red: 255, green: 255, blue: 255, alpha: 255};
  public liveListBgColor: ResourceColor =
    this.isNtfBrightnessDisable ? $r('app.color.live_heads_up_disable_brightness_bg_color') :
    $r('app.color.ntf_brightness_bg_color')

}