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

import { AttributeUpdater } from '@ohos.arkui.modifier';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'AppIconBaseModifier';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

/**
 * 实现基本的AppIconModifier
 */
export abstract class AppIconBaseModifier extends AttributeUpdater<CommonAttribute> {
  private tag: string = 'AppIconBaseModifier';

  public setTag(tag: string): AttributeUpdater<CommonAttribute> {
    this.tag = tag;
    return this;
  }

  public setOpacity(value: number | Resource, caller: string): AttributeUpdater<CommonAttribute> {
    log.showWarn(`${this.tag}: setOpacity: ${value}, caller: ${caller}.`);
    this.attribute?.opacity(value);
    return this;
  }

  public setVisibility(value: Visibility, caller: string): AttributeUpdater<CommonAttribute> {
    log.showWarn(`${this.tag}: setVisibility: ${value === Visibility.Visible ? 'visible' : 'hidden'},` +
      `caller: ${caller}.`);
    this.attribute?.visibility(value);
    return this;
  }

  public setWidth(value: Length): AttributeUpdater<CommonAttribute> {
    this.attribute?.width(value);
    return this;
  }

  public setHeight(value: Length): AttributeUpdater<CommonAttribute> {
    this.attribute?.height(value);
    return this;
  }

  public setMargin(value: Margin | Length | LocalizedMargin): AttributeUpdater<CommonAttribute> {
    this.attribute?.margin(value);
    return this;
  }

  public setOffset(value: Position | Edges | LocalizedEdges): AttributeUpdater<CommonAttribute> {
    this.attribute?.offset(value);
    return this;
  }

  public setPadding(value: Padding | Length | LocalizedPadding): AttributeUpdater<CommonAttribute> {
    this.attribute?.padding(value);
    return this;
  }

  public setScale(value: ScaleOptions): AttributeUpdater<CommonAttribute> {
    this.attribute?.scale(value);
    return this;
  }

  public setTranslate(value: TranslateOptions): AttributeUpdater<CommonAttribute> {
    this.attribute?.translate(value);
    return this;
  }

  public setHitTestBehavior(value: HitTestMode): AttributeUpdater<CommonAttribute> {
    this.attribute?.hitTestBehavior(value);
    return this;
  }

  public setBackgroundColor(value: ResourceColor): AttributeUpdater<CommonAttribute> {
    this.attribute?.backgroundColor(value);
    return this;
  }

  public setBackgroundBlurStyle(value: BlurStyle, options?: BackgroundBlurStyleOptions | undefined):
    AttributeUpdater<CommonAttribute> {
    this.attribute?.backgroundBlurStyle(value, options, { disableSystemAdaptation: true });
    return this;
  }

  public setBlur(value: number, options?: BlurOptions): AttributeUpdater<CommonAttribute> {
    this.attribute?.blur(value, options, { disableSystemAdaptation: true });
    return this;
  }
}