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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { WidgetBindState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import {
  EditBindStateType,
  SlMainStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ClockEditorStyle, ClockEditorStyleManager } from './EditorConfig';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { ClockLayoutTab, EditToolType, EditPanelPos } from '../utils/Contants';
import { AnyClock } from '../models/AnyClock';
import { GridAmount } from '../../clock/common/ClockLayoutHelper';

const TAG = 'SlEditorBindState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const TOOLBAR_WIDTH_NORMAL = 224;

// 锁屏编辑面板UI绑定状态
@Observed
export class SlEditorBindState extends WidgetBindState<EditBindStateType> {
  private widgetName: string = 'defaultEditor';

  /**
   * Toolbar的宽度,默认值未未打开艺术签名特性时的值
   */
  @Track private toolbarWidth: number = TOOLBAR_WIDTH_NORMAL;

  /**
   * 当前选择的时钟编辑样式类型
   */
  @Track private layoutTab: ClockLayoutTab = ClockLayoutTab.LAYOUT_TAB_CLOCK;

  /**
   * 当前选择的时钟编辑样式类型，动效过渡
   */
  @Track private layoutAnimTab: ClockLayoutTab = ClockLayoutTab.LAYOUT_TAB_CLOCK;

  /**
   * 锁屏编辑面板按钮透明度
   */
  @Track private editPanelActionAlpha: number = 1;

  /**
   * 时钟编辑面板参数管理类实例
   */
  @Track public clockEditorStyleManager: ClockEditorStyleManager | undefined;

  /**
   * 当前选择的时钟编辑面板类型，如样式编辑、字体编辑、颜色编辑
   */
  @Track private editToolType: EditToolType = EditToolType.Layout;

  /**
   * 内容面板动态区域的真实高度（内容面板除去三个静态按钮）
   */
  @Track private contentDynamicH: number = 0;

  /**
   * Clock数据对象
   */
  @Track private clockObject?: AnyClock;

  /**
   * 当前屏幕下时钟可用栅格最大值
   */
  @Track private clockAmount: GridAmount = { x: 0, y: 0 };

  // 时钟外边框的位置
  @Track private clockBoardArea?: Area;

  // 编辑面板位置（优先级按照下、左、右、上）
  @Track private editPanelPostion: EditPanelPos = EditPanelPos.Bottom;

  // 编辑内容面板的可显示高度
  @Track private contentPanelAllowH: number = 0;

  // 编辑面板的左偏移量
  @Track private editorPaddingLeft: number = 0;

  // 编辑面板的右偏移量
  @Track private editorPaddingRight: number = 0;

  // 编辑面板的上偏移量
  @Track private editorPaddingTop: number = 0;

  // 编辑面板的下偏移量
  @Track private editorPaddingBottom: number = 0;
  /**
   * 选中字体颜色索引
   */
  @Track private selectedColorIndex: number = 0;

  /**
   * 锁屏签名半模态框宽度
   */
  @Track private bindSheetWidth: number = 0;

  constructor(name?: string) {
    super(SlMainStateType.SL_EDIT_BIND_STATE);
    if (name) {
      this.widgetName = name;
    }
    this.initSetMethods();
    this.initGetMethods();
  }

  protected initSetMethods(): void { // 赋值函数统一管理
    this.setMethods.set(EditBindStateType.SL_EDIT_TOOLBAR_WIDTH, this.setMethodToolbarWidth);
    this.setMethods.set(EditBindStateType.SELECTED_COLOR_INDEX, this.setMethodSelectedColor);
  }

  protected initGetMethods(): void { // 取值函数统一管理
    this.getMethods.set(EditBindStateType.SL_EDIT_TOOLBAR_WIDTH, this.getMethodToolbarWidth);
    this.getMethods.set(EditBindStateType.SELECTED_COLOR_INDEX, this.getMethodSelectedColor);
  }

  private setMethodToolbarWidth(st: SlEditorBindState, toolbarWidth: number): void {
    st.setToolbarWidth(toolbarWidth);
  }

  /**
   * 设置Toolbar宽度
   *
   * @param toolbarWidth Toolbar宽度
   */
  public setToolbarWidth(toolbarWidth: number): void {
    if (toolbarWidth !== this.toolbarWidth) {
      this.toolbarWidth = toolbarWidth;
      this.notifyStateChange(EditBindStateType.SL_EDIT_TOOLBAR_WIDTH);
    }
  }

  private getMethodToolbarWidth(st: SlEditorBindState): number {
    return st.getToolbarWidth();
  }

  private setMethodSelectedColor(st: SlEditorBindState, index: number): void {
    st.setColorIndex(index);
  }

  private getMethodSelectedColor(st: SlEditorBindState): number {
    return st.getColorIndex();
  }



  /**
   * 获取Toolbar宽度
   * @returns Toolbar宽度
   */
  public getToolbarWidth(): number {
    return this.toolbarWidth;
  }

  /**
   * 是否支持数字时钟签名
   * @returns boolean
   */
  isComSignatureEnable(): boolean {
    // 默认支持数字签名
    return true;
  }

  /**
   * 美学全能力推荐是否开启
   *
   * @returns true开启
   */
  public isAestheticAllEnable(): boolean {
    // 艺术签名能力开启时，即可全推荐
    return false;
  }

  /**
   * 设置时钟编辑面板类型，数字时钟/艺术签名
   *
   * @param layoutTab 面板类型
   * @param refreshAnim 同步刷新动效类型
   */
  setLayoutTab(layoutTab: ClockLayoutTab, refreshAnim: boolean = true): void {
    if (this.layoutTab !== layoutTab) {
      this.layoutTab = layoutTab;
    }
    if (refreshAnim) {
      this.setLayoutAnimTab(layoutTab);
    }
  }

  /**
   * 获取当前的时钟编辑面板类型
   */
  getLayoutTab(): ClockLayoutTab {
    return this.layoutTab ?? ClockLayoutTab.LAYOUT_TAB_CLOCK;
  }

  /**
   * 当前是否选择了数字时钟样式
   * @returns boolean
   */
  isLayoutTabClock(): boolean {
    return this.layoutTab === ClockLayoutTab.LAYOUT_TAB_CLOCK;
  }

  /**
   * 设置时钟编辑面板类型，数字时钟/艺术签名
   *
   * @param layoutTab 面板类型
   */
  setLayoutAnimTab(layoutTab?: ClockLayoutTab): void {
    let resultTab = layoutTab ?? this.layoutTab;
    if (this.layoutAnimTab !== resultTab) {
      this.layoutAnimTab = resultTab;
    }
  }

  /**
   * 获取当前的时钟编辑面板类型
   */
  getAnimTab(): ClockLayoutTab {
    return this.layoutAnimTab ?? ClockLayoutTab.LAYOUT_TAB_CLOCK;
  }

  /**
   * 当前是否选择了数字时钟样式
   *
   * @returns boolean
   */
  isAnimTabClock(): boolean {
    return this.layoutAnimTab === ClockLayoutTab.LAYOUT_TAB_CLOCK;
  }

  /**
   * 获取时钟编辑面板参数的UI配置信息，影响参数：屏幕断点
   * @returns 时钟编辑面板的UI配置信息
   */
  getEditorStyle(): ClockEditorStyle {
    let clockEditorStyle: ClockEditorStyle = new ClockEditorStyle();
    this.clockEditorStyleManager?.setStyle(clockEditorStyle);
    return clockEditorStyle;
  }

  /**
   * 设置编辑按钮透明度
   *
   * @param alpha 透明度
   */
  public setButtonAlpha(alpha: number): void {
    if (alpha !== this.editPanelActionAlpha) {
      this.editPanelActionAlpha = alpha;
    }
  }

  /**
   * 获取编辑按钮透明度
   *
   * @param alpha 透明度
   */
  public getButtonAlpha(): number {
    return this.editPanelActionAlpha;
  }

  public getTabAlign(): Alignment {
    return this.isAnimTabClock() ? Alignment.Start : Alignment.End;
  }

  /**
   * 设置时钟编辑面板类型
   * @param layoutTab 面板类型
   */
  setEditToolType(editToolType: EditToolType): void {
    if (this.editToolType !== editToolType) {
      log.showInfo(`tool bar click, type is ${editToolType}`);
      this.editToolType = editToolType;
    }
  }

  /**
   * 获取当前的时钟编辑面板类型
   */
  getEditToolType(): EditToolType {
    return this.editToolType;
  }

  setContentDynamicH(height: number): void {
    if (this.contentDynamicH !== height) {
      this.contentDynamicH = height;
    }
  }

  getContentDynamicH(): number {
    return this.contentDynamicH;
  }

  setClockObject(clockObj: AnyClock): void {
    if (this.clockObject !== clockObj) {
      this.clockObject = clockObj;
    }
  }

  getClockObject(): AnyClock {
    return this.clockObject ?? new AnyClock();
  }

  setClockAmount(amount: GridAmount): void {
    let x = amount?.x ?? 0;
    let y = amount?.y ?? 0;
    if (this.clockAmount.x !== x || this.clockAmount.y !== y) {
      this.clockAmount = { x: x, y: y };
      this.notifyStateChange(EditBindStateType.SL_EDIT_CLOCK_AMOUNT);
      log.showInfo(`setClockAmount amount: ${x}, ${y}`);
    }
  }

  getClockAmount(): GridAmount {
    return this.clockAmount;
  }

  setClockBoardArea(clockArea?: Area): void {
    if (this.clockBoardArea !== clockArea) {
      this.clockBoardArea = clockArea;
    }
  }

  getClockBoardArea(): Area | undefined {
    return this.clockBoardArea;
  }

  setEditPanelPos(postion: EditPanelPos): void {
    if (this.editPanelPostion !== postion) {
      this.editPanelPostion = postion;
    }
  }

  getEditPanelPos(): EditPanelPos {
    return this.editPanelPostion;
  }

  setContentAllowH(contentHeight: number): void {
    if (this.contentPanelAllowH !== contentHeight) {
      this.contentPanelAllowH = contentHeight;
    }
  }

  getContentAllowH(): number {
    return this.contentPanelAllowH;
  }

  public setPaddingTop(paddingTop: number): void {
    if (this.editorPaddingTop !== paddingTop) {
      this.editorPaddingTop = paddingTop;
    }
  }

  public getPaddingTop(): number {
    return this.editorPaddingTop;
  }

  public setPaddingBottom(paddingBottom: number): void {
    if (this.editorPaddingBottom !== paddingBottom) {
      this.editorPaddingBottom = paddingBottom;
    }
  }

  public getPaddingBottom(): number {
    return this.editorPaddingBottom;
  }

  public setPaddingLeft(paddingLeft: number): void {
    if (this.editorPaddingLeft !== paddingLeft) {
      this.editorPaddingLeft = paddingLeft;
    }
  }

  public getPaddingLeft(): number {
    return this.editorPaddingLeft;
  }

  public setPaddingRight(paddingRight: number): void {
    if (this.editorPaddingRight !== paddingRight) {
      this.editorPaddingRight = paddingRight;
    }
  }

  public getPaddingRight(): number {
    return this.editorPaddingRight;
  }

  public setColorIndex(index: number): void {
    if (this.selectedColorIndex !== index) {
      this.selectedColorIndex = index;
    }
    this.notifyStateChange(EditBindStateType.SELECTED_COLOR_INDEX);
  }

  public getColorIndex(): number {
    return this.selectedColorIndex;
  }

  public setBindSheetWidth(bindSheetWidth: number): void {
    if (this.bindSheetWidth !== bindSheetWidth) {
      this.bindSheetWidth = bindSheetWidth;
    }
  }

  public getBindSheetWidth(): number {
    return this.bindSheetWidth;
  }
}