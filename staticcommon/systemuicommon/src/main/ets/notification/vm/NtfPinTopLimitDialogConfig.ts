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
import { LengthMetrics } from '@kit.ArkUI';

export class NtfPinTopLimitDialogConfig {
  //置顶通知超过数量限制提示弹框相关参数

  //组件内外边距
  public ntfAppIconTopMargin = 2;
  public dialogTextRightPadding = 24;
  public dialogTextTopPadding = 18;
  public dialogTextBottomPadding = 22;
  public dialogGridcolPadding = 16;
  public dialogGridrowMargin = 12;
  public dialogTextVerticalPadding = 0;
  public ntfPinTopGridCloXGutter = 12;
  public buttonTopMargin = 0;
  public buttonBottomMargin = 0;
  public buttonRowOutMargin = 0;
  public buttonRowInnerMargin = 0;
  public buttonOutTopMargin = 8;
  public buttonOutBottomRightLeftMargin = 16;

  public ntfMenuDialogRadio = 32;
  public titleContentFontSize = 18;

  public actionButtonBkgColor: ResourceColor = Color.Transparent;
  public buttonInnerLineVisibility: Visibility = Visibility.Visible;
  public actionButtonType: ButtonType = ButtonType.Capsule;
  // 每行显示列的数量
  public colCount: number = 3;
  public actionButtonWidth?: number = undefined;
  public buttonEnabled?: boolean = undefined;
  public buttonOpacity?: number = undefined;
  public buttonUnableOpacity?: number = 0.6;

  public ntfSettingDialogItemHeight: number = 40;
  public ntfSettingDialogContentLineHeight: number = 21;
  public ntfSettingDialogTitleHeight: number = 56;
  public ntfPinTopAppIconSize: number = 56;
  public ntfPinTopAppIconMargin: number = 8;
  public ntfPinTopAppIconRowMarginGap: number = 10;
  public ntfPinTopAppNameLineHeight: number = 16;
  public ntfPinTopAppLayoutMargin: number = 20;
  public ntfMenuDialogTextPadding: number = 24;
  public ntfPinTopPaddingLeftRight: number = 16;

  public ntfPinTopAppIconConstraintSize: number = 72;
  public ntfPinTopAppIconCheckboxOffsetStart: number = 24;
  public ntfPinTopAppIconCheckboxOffsetTop: number = 12;
  public ntfPinTopAppIconCheckboxWidth?: number = undefined;
  public ntfPinTopAppIconCheckboxHeight?: number = undefined;

  public ntfPinTopAppNameFontSize: number = 12;
  public ntfPinTopAppNameMaxFontSize: number = 12;
  public ntfPinTopAppNameMinFontSize: number = 10;
  public ntfPinTopAppNameTopMargin: number = 0;
  public ntfTitleContentTopMargin: number = 0;
  public ntfDialogContentFontSize: number = 16;
  public ntfDialogContentLineHeight: number = 21;
  public ntfActionButtonFontSize: number | undefined = undefined;
  public ntfActionButtonFontColor: ResourceColor | undefined = undefined;

  public ntfGridColumnsGap: number = 22;
  public ntfGridRowsGap: number = 18;

  public dialogMaskBgColor: ResourceColor = Color.Transparent;
  public dialogBgColor: ResourceColor | undefined = undefined;
  public ntfTitleContentAlign: TextAlign = TextAlign.Center;
}