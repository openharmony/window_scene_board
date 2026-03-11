/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

const OVERLAY_BUTTON_PRESS_SCALE: ScaleOptions = {
  x: 0.9,
  y: 0.9,
  centerX: '50%',
  centerY: '50%'
};
const OVERLAY_BUTTON_NORMAL_SCALE: ScaleOptions = {
  x: 1,
  y: 1,
  centerX: '50%',
  centerY: '50%'
};

export class OverlayButtonModifier implements AttributeModifier<ButtonAttribute> {
  applyNormalAttribute(instance: ButtonAttribute) {
    instance.scale(OVERLAY_BUTTON_NORMAL_SCALE);
  }

  applyPressedAttribute(instance: ButtonAttribute) {
    instance.scale(OVERLAY_BUTTON_PRESS_SCALE);
  }
}