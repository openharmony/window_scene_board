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

import { FormCenterViewModel } from '../viewmodel/FormCenterViewModel';
import { NavDestinationStyle } from './NavDestinationStyle';
import { TileLayoutStyle } from './TileLayoutStyle'

export class NavTileStyle {
  public tileLayoutStyle: TileLayoutStyle = new TileLayoutStyle();
  public navDestinationStyle: NavDestinationStyle = new NavDestinationStyle();

  constructor() {
    this.updateFormNameStyle();
  }

  private updateFormNameStyle(): void {
    this.navDestinationStyle.margin = { bottom: 28, };
    this.tileLayoutStyle.formNameStyle.appNameFontSize = $r('sys.float.ohos_id_text_size_body2');
    this.tileLayoutStyle.formNameStyle.appNameFontWeight = FontWeight.Regular;
    this.tileLayoutStyle.formNameStyle.appNameHeight = undefined;
    this.tileLayoutStyle.formNameStyle.appNameLineHeight = undefined;
    this.tileLayoutStyle.formNameStyle.appNameMargin = { top: 4, bottom: 2 };

    this.tileLayoutStyle.formNameStyle.descriptionFontSize = $r('sys.float.ohos_id_text_size_body3');
    this.tileLayoutStyle.formNameStyle.descriptionHeight = undefined;
    this.tileLayoutStyle.formNameStyle.descriptionMaxLines = 1;
    this.tileLayoutStyle.formNameStyle.descriptionLineHeight = undefined;
    this.tileLayoutStyle.formNameStyle.descriptionMargin = undefined;
    this.tileLayoutStyle.formNameStyle.descriptionMargin = { bottom: 4 };
  }
}