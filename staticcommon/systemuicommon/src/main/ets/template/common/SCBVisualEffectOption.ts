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

import { SCBVisualEffectManagerAdapter } from '../../adapter/SCBVisualEffectManagerAdapter';
import { VisualEffectConstants } from '@ohos/commonconstants';

// 控制中心/通知中心 OpenHarmony Lite 轻量化配置项

export const NTF_BRIGHTENS_CENTRALIZED: boolean = SCBVisualEffectManagerAdapter.isFeatureParamTrue(
    VisualEffectConstants.NTF_BRIGHTENS_CENTRALIZED);
export const DISABLE_BRIGHTNESS: boolean = SCBVisualEffectManagerAdapter.isFeatureParamTrue(
    VisualEffectConstants.CC_BRIGHTNESS_DISABLE);
export const ENABLE_SOLID_COLOR: boolean = SCBVisualEffectManagerAdapter.isFeatureParamTrue(
    VisualEffectConstants.CC_SOLID_COLOR_ENABLE);
export const SOLID_COLOR_USE_FIXED_COLOR: boolean = SCBVisualEffectManagerAdapter.isFeatureParamTrue(
    VisualEffectConstants.CC_SOLID_COLOR_USE_FIXED_COLOR);
export const DISABLE_PIXEL_STRETCH_EFFECT: boolean = SCBVisualEffectManagerAdapter.isFeatureParamTrue(
    VisualEffectConstants.CC_PIXEL_STRETCH_EFFECT_DISABLE);
export const DISABLE_HEAD_BLUR_EFFECT: boolean = SCBVisualEffectManagerAdapter.isFeatureParamTrue(
    VisualEffectConstants.CC_HEAD_BLUR_EFFECT_DISABLE);
export const ABLE_DROPDOWN_PANEL_ROTATION: boolean = SCBVisualEffectManagerAdapter.isFeatureParamTrue(
    VisualEffectConstants.CC_DROPDOWN_PANEL_ROTATION_ABLE);
export const ENABLE_FORCE_CLOSE_HDR: boolean = SCBVisualEffectManagerAdapter.isFeatureParamTrue(
    VisualEffectConstants.CC_DROPDOWN_PANEL_FORCE_CLOSE_HDR_ENABLE);
export const ANIMATION_BLUR_POLICY: string | undefined = SCBVisualEffectManagerAdapter.getFeatureParam(
    VisualEffectConstants.CC_ANIMATION_BLUR_POLICY);
export const ANIMATION_BLUR_STOP_TIME_NORMAL: string | undefined = SCBVisualEffectManagerAdapter.getFeatureParam(
    VisualEffectConstants.CC_ANIMATION_BLUR_STOP_TIME_NORMAL);
export const ANIMATION_BLUR_STOP_TIME_ABNORMAL: string | undefined = SCBVisualEffectManagerAdapter.getFeatureParam(
    VisualEffectConstants.CC_ANIMATION_BLUR_STOP_TIME_ABNORMAL);
export const ANIMATION_BLUR_CANCEL_THERMAL_LEVEL: string | undefined = SCBVisualEffectManagerAdapter.getFeatureParam(
    VisualEffectConstants.CC_ANIMATION_BLUR_CANCEL_THERMAL_LEVEL);
