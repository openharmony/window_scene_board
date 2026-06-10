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

import { LockscreenFormConfig } from '../../common/WidgetParam';

@Observed
export default class FormPlaceHolderInfo {
  public isDrag?: boolean = false;
  public positionX: number = 0;
  public positionY: number = 0;
  public dimensionX: number = 0;
  public isForm?: boolean;
  public newX?: number;
  public newY?: number;
  public isVisible?: boolean;
  public isPlaceholder?: boolean;
  public dragForms?: LockscreenFormConfig;

  public static buildForm(isDrag: boolean, form: LockscreenFormConfig,
    holderInfo: FormPlaceHolderInfo): FormPlaceHolderInfo {
    holderInfo.isDrag = isDrag;
    holderInfo.positionX = form.positionX;
    holderInfo.positionY = form.positionY;
    holderInfo.dimensionX = form.dimensionX;
    holderInfo.isForm = undefined;
    holderInfo.newX = form.positionX;
    holderInfo.newY = form.positionY;
    holderInfo.isVisible = false;
    holderInfo.isPlaceholder = undefined;
    holderInfo.dragForms = form;
    return holderInfo;
  }

  public static buildDefault(holderInfo: FormPlaceHolderInfo): FormPlaceHolderInfo {
    holderInfo.isDrag = false;
    holderInfo.newX = undefined;
    holderInfo.newY = undefined;
    holderInfo.isVisible = true;
    holderInfo.isPlaceholder = undefined;
    // 强制触发一次刷新
    holderInfo.dragForms = new LockscreenFormConfig();
    holderInfo.dragForms = undefined;
    holderInfo.positionX = 0;
    holderInfo.positionY = 0;
    holderInfo.dimensionX = 0;
    holderInfo.isForm = undefined;
    return holderInfo;
  }
}