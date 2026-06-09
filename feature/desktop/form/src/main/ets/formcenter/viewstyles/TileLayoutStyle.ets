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

import { FormDescriptionStyle } from './FormDescriptionStyle';
import { FormItemStyle } from './FormItemStyle'

export class TileLayoutStyle {
  public formItemStyle: FormItemStyle = new FormItemStyle();
  public formNameStyle: FormDescriptionStyle = new FormDescriptionStyle();

  // GridRow
  public gridRowColumns?: number;
  public gridRowPadding?: Padding | Length | LocalizedPadding = { top: 8 };

  constructor() {
    this.formNameStyle.descriptionAccessibilityGroup = false;
    this.formNameStyle.descriptionAccessibilityLevel = true;
    this.formItemStyle.stackAccessibilityLevel = true;
  }
}