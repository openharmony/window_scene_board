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

interface SystemShutdownStyleProps {
  //公共的
  textLineHeight: number;
  titleMarginLeft: number;
  titleMarginRight: number;
  titleMarginTop: number;
  titleMarginBottom: number;
  buttonHeight: number;
  mediumFontSize: number;
  smallFontSize: number;
  bigFontSize: number;
  shadowRadius: number;
  shadowOffsetX: number;
  shadowOffsetY: number;
  buttonMarginBottom: number;
  shutdownTimerConstant: number;

  // 正在关机界面
  loadingSize: number;
  loadingTextMargin: number;

  // 正在关闭的应用弹窗
  confirmDialogWidth: number;
  confirmDialogBkgBlur: number;
  confirmDialogMaxHeight: number;
  confirmDialogBorderRadius: number;
  confirmButtonWidth: number;
  confirmDlgDetailTipWidth: number;
  appListMaxHeight: number;
  appListItemHeight: number;
  appListItemMarginRight: number;
  appListItemMarginTop: number;
  appListItemMarginBottom: number;
  appListIconSize: number;
  appIconBorderRadius: number;
  appOutlineWidth: number;
  appOutlineColor: string;
  appListNameLineHeight: number;
  appListNotSavingLineHeight: number;
  confirmButtonSpacingSize: number;
  confirmDlgDefaultHeight: number;
  appListTitleWidth: number;
  appListDividerWidth: number;
  appListItemMargin: number;
  appNameMarginBottom: number;
  appNameMarginTop: number;
  appListMarginBottom: number;
  appNotSavingWarningColor: string;

  // 虚拟机弹窗
  virtualMachineCloseDialogHeight: number;
  virtualMachineIconTop: number;
  virtualMachineIconSize: number;
  virtualMachineIconRadius: number;
  virtualMachineNameLineHeight: number;
  virtualMachineNameWidth: number;
  virtualMachineIconBottom: number;
  virtualMachineWarningTop: number;
  virtualMachineWarningBottom: number;
  virtualMachineButtonBottom: number;
}

export const SystemShutdownStyle: SystemShutdownStyleProps = {
  textLineHeight: 24,
  titleMarginLeft: 24,
  titleMarginRight: 24,
  titleMarginTop: 16,
  titleMarginBottom: 16,
  buttonHeight: 40,
  mediumFontSize: 16,
  smallFontSize: 14,
  bigFontSize: 20,
  shadowRadius: 120,
  shadowOffsetX: 0,
  shadowOffsetY: 20,
  buttonMarginBottom: 16,
  loadingSize: 64,
  loadingTextMargin: 8,
  confirmDialogWidth: 400,
  confirmDialogBkgBlur: 50,
  confirmDialogMaxHeight: 694,
  confirmDialogBorderRadius: 16,
  confirmButtonWidth: 176,
  confirmDlgDetailTipWidth: 352,
  appListMaxHeight: 206,
  appListItemHeight: 64,
  appListItemMarginRight: 16,
  appListItemMarginTop: 8,
  appListItemMarginBottom: 8,
  appListIconSize: 48,
  appIconBorderRadius: 12,
  appOutlineWidth: 0.5,
  appOutlineColor: '#80808033',
  appListNameLineHeight: 21,
  appListNotSavingLineHeight: 19,
  confirmButtonSpacingSize: 16,
  confirmDlgDefaultHeight: 120,
  appListTitleWidth: 288,
  appListDividerWidth: 288,
  appListItemMargin: 24,
  appNameMarginBottom: 11,
  appNameMarginTop: 11,
  appListMarginBottom: 16,
  shutdownTimerConstant: 1000, //定时器
  virtualMachineCloseDialogHeight: 254,
  virtualMachineIconTop: 24,
  virtualMachineIconSize: 64,
  virtualMachineIconRadius: 16.6,
  virtualMachineNameLineHeight: 27,
  virtualMachineNameWidth: 300,
  virtualMachineIconBottom: 16,
  virtualMachineWarningTop: 8,
  virtualMachineWarningBottom: 16,
  virtualMachineButtonBottom: 17,
  appNotSavingWarningColor: '#ED6F21'
}