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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG: string = 'EditorConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 时钟编辑面板可配置样式参数
export class ClockEditorStyle {
  public editorPanelWidth: number = 1; // 编辑面板宽度
  public panelRadius: number = 16; // 各个根面板的圆角
  public editorClockSpace: number = 8; // 编辑面板与时钟组件的间距
  public layoutPanelHeightD: number = 302; // 数字时钟样式选择面板高度
  public layoutPanelHeightArt: number = 161; // 艺术签名时钟样式选择面板静态区域高度
  public selectTabSpace: number = 25; // 样式TAB的间距 ['数字时钟', '海报样式']的间距
  public selectTabSignalWidth: number = 110; // 样式TAB的['数字时钟', '海报样式']的宽度
  public selectTabFontSize: number = 14; // 样式TAB的字体大小 ['数字时钟', '海报样式']的字体大小
  public selectTabClickHotZone: number = 27; // 样式TAB的点击热区宽度
  public rowMaxSizeLayout: number = 4; // 每行可选样式的最大个数
  public rowMaxSizeFont: number = 4; // 每行可选字体的最大个数
  public rowsTemplate: string = 'repeat(auto-fit, 200px)'; // 可选样式网格行排列布局参数
  public rowsPadding: Padding = { left: 7, right: 7 }; // 可选样式网格行内边距
  public rowsGap: number = 16; // 可选样式网格行间距
  public previewHeight: number = 65; // 艺术签名样式预览图的高度
  public columnsTemplate: string = '1fr 1fr 1fr 1fr'; // 网格列排列布局参数
  public artSignInputPanelH: number = 88; // 艺术签名输入面板高度
  public inputTitleFontSize: string = '16vp'; // 输入框提示文本的字体大小 ['海报文本']
  public inputTileTipSpace: number = 5; // 输入框提示文本与输入限制提示图标的间距
  public inputTipIconWidth: number = 12; // 输入限制提示图标的大小
  public inputTipIconHeight: number = 16; // 输入限制提示图标的大小
  public inputTipIconAlpha: number = 0.4; // 输入限制提示图标的透明度
  public inputOffsetY: number = -43; // 输入框居中后，为了不与键盘重叠所避让的距离.

  public artSignTabFlagLineWidth: number = 66; // 签名样式选择TAB下划线宽度
  public artSignTabFlagLineHeight: number = 2; // 签名样式选择TAB下划线高度
  public artSignTabFlagLineBoardRadius: number = 2; // 签名样式选择TAB下划线圆角
  public artSignTabFlagLineMargin: Margin = { top: 25 }; // 签名样式选择TAB下划线margin
  public artSignTabMargin: Margin = { top: 10 }; // 签名样式选择TAB边距
  public signInputWidth: Length = '90%'; // 签名输入组件宽度
  public artSignInputMargin: Margin = { top: 20 }; // 艺术签名输入框外边距
  public signTextHeight: number = 40; // 签名文本框高度
  public signTextBorderRadius: number = 20; // 签名文本框圆角
  public artSignTextMargin: Margin = { top: 16, bottom: 18 }; // 签名文本框外边距
  public artSignTextPadding: Padding = { left: 12, right: 12 }; // 签名文本框内边距
  public artSignInputPadding: Padding = { left: 16, right: 16 }; // 艺术签名输入框内边距
  public layoutSignPanelMargin: Padding = { top: -16 }; // 签名文本框内边距
  public popupOffset: Position = { x: -27 }; // 签名提示气泡位移
  public editorPanelPadding: Padding = { top: 402 }; // 大尺寸艺术签名时的编辑面板位置
  public maxPanelHeight: number = 355; // 艺术签名样式时允许的最大面板高度
}

export class ClockEditorStyleManager {
  /**
   * 根据不同产品定制值
   *
   * @param curStyle: 传入的通用style
   */
  public setStyle(curStyle: ClockEditorStyle): void {
  }
}