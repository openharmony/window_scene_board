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

import { MethodMap, SlCapStaticStPt, SlStateId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import lazy {
  CcmOption,
  SlAreaType,
  SlPositionType,
  SlVisualConfigManager,
  SlVisualControl,
  SolidColorListener
} from '@ohos/screenlockcommon';
import { AnimEvent, SlViewStaticState, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { ISolidVisualControl } from '../../../common/interface/ISolidVisualControl';
import { ImmCapDataArray } from './ImmCapDataArray';

/**
 * 沉浸胶囊静态状态管理器
 */
export class SlCapStaticStateV2 extends SlViewStaticState<SlCapStaticStPt> implements ISolidVisualControl {
  // 沉浸胶囊数据集
  private readonly _capData: ImmCapDataArray = new ImmCapDataArray();

  // 纯色赋值函数集
  private _solidSetMethod?: MethodMap<SlCapStaticStateV2>;

  // 胶囊中按钮纯色模式下背景颜色
  private _btnSolidBgColor?: ResourceColor;

  // 主胶囊条目纯色模式下背景颜色
  private _mainCapSolidBgColor?: ResourceColor;

  // 阴影胶囊条目纯色模式下背景颜色
  private _shadowCapSolidBgColor?: ResourceColor;

  // 主胶囊条目纯色模式下前景颜色
  private _mainCapSolidFgColor?: ResourceColor;

  // 阴影胶囊条目纯色模式下前景颜色
  private _shadowCapSolidFgColor?: ResourceColor;

  // 扩展区文本纯色模式下前景颜色
  private _extTextSolidFgColor?: ResourceColor;

  // 扩展区按钮纯色模式下背景颜色
  private _extBtnSolidBgColor?: ResourceColor;

  // 胶囊AOD一镜到底动效打断器
  private _aodMirrorInterrupt?: AnimEvent;

  // 数据刷新后及时执行任务
  private _updateDataRunnable?: AnimEvent;

  /**
   * 监听纯色模式刷新，触发胶囊元素颜色刷新
   */
  private readonly _solidListener: SolidColorListener = {
    onColorChange: () => this.updateInnerSolidColor()
  }

  protected constructor() {
    super(SlStateId.SL_CAP_STATE);
  }

  protected init(): void {
    this._solidSetMethod = new MethodMap(this);
    super.init();
  }

  protected initSetMethods(): void {
    super.initSetMethods();
    this.addSetMethod(SlCapStaticStPt.PT_AOD_MIRROR_INTERRUPT, this.setAodMirrorInterrupt);
    this._solidSetMethod?.addSetMethod(SlCapStaticStPt.PT_BTN_SOLID_BG_COLOR, this.setBtnSolidBgColor);
    this._solidSetMethod?.addSetMethod(SlCapStaticStPt.PT_MAIN_CAP_SOLID_BG_COLOR, this.setMainCapSolidBgColor);
    this._solidSetMethod?.addSetMethod(SlCapStaticStPt.PT_SHADOW_CAP_SOLID_BG_COLOR, this.setShadowCapSolidBgColor);
    this._solidSetMethod?.addSetMethod(SlCapStaticStPt.PT_MAIN_CAP_SOLID_FG_COLOR, this.setMainCapSolidFgColor);
    this._solidSetMethod?.addSetMethod(SlCapStaticStPt.PT_SHADOW_CAP_SOLID_FG_COLOR, this.setShadowCapSolidFgColor);
    this._solidSetMethod?.addSetMethod(SlCapStaticStPt.PT_EXT_TEXT_SOLID_FG_COLOR, this.setExtTextSolidFgColor);
    this._solidSetMethod?.addSetMethod(SlCapStaticStPt.PT_EXT_BTN_SOLID_BG_COLOR, this.setExtBtnSolidFgColor);
  }

  /**
   * 纯色模式开关
   *
   * @returns true纯色模式开启
   */
  public isSolidEnable(): boolean {
    return SlVisualConfigManager.getInstance().getEnable(CcmOption.SOLID, SlAreaType.CAPSULE);
  }

  /**
   * 禁用提亮开关
   *
   * @returns true禁用提亮
   */
  public isDisableBright(): boolean {
    return !SlVisualControl.getInstance().getEnable(CcmOption.BRIGHT, SlAreaType.CAPSULE);
  }

  /**
   * 纯色业务管理
   */
  public solidInit(): void {
    // 监听胶囊区域纯色颜色切换
    if (this.isSolidEnable()) {
      this.updateInnerSolidColor();
      SlVisualControl.getInstance().registerSolidListener(SlAreaType.CAPSULE, this._solidListener);
    }
  }

  /**
   * 纯色业务管理
   */
  public solidDestroy(): void {
    if (this.isSolidEnable()) {
      SlVisualControl.getInstance().unregisterSolidListener(SlAreaType.CAPSULE, this._solidListener);
    }
  }

  /**
   * 刷新纯色样式
   *
   * @param solidStyle 纯色样式
   */
  public updateSolidColor(solidStyle: WidgetStyleStateV2): void {
    this._solidSetMethod?.callSetMethod(solidStyle?.getConfigId(), solidStyle);
  }

  /**
   * 沉浸胶囊模块数据集
   *
   * @returns 胶囊数据集
   */
  public getCapData(): ImmCapDataArray {
    return this._capData;
  }

  /**
   * 赋值胶囊AOD一镜到底动效打断器
   *
   * @param interrupt 动效打断器
   */
  public setAodMirrorInterrupt(interrupt?: AnimEvent): void {
    if (this._aodMirrorInterrupt !== interrupt) {
      this._aodMirrorInterrupt = interrupt;
      this.notifyStateChange(SlCapStaticStPt.PT_AOD_MIRROR_INTERRUPT);
    }
  }

  /**
   * AOD一镜到底动效打断器
   *
   * @returns 动效打断器
   */
  public getAodMirrorInterrupt(): AnimEvent | undefined {
    return this._aodMirrorInterrupt;
  }

  /**
   * 数据刷新时及时任务
   *
   * @param runnable 及时任务
   */
  public setUpdateDataRunnable(runnable?: AnimEvent): void {
    if (this._updateDataRunnable !== runnable) {
      this._updateDataRunnable = runnable;
    }
  }

  /**
   * 执行及时任务
   */
  public exeUpdateDataRunnable(): void {
    this._updateDataRunnable?.();
  }

  private updateInnerSolidColor(): void {
    // 刷新纯色模式颜色
    if (!this.isSolidEnable()) {
      return;
    }
    // 胶囊按钮背景颜色
    let btnBgColor = this.getSolidColor(SlPositionType.SL_CAP_FIRST_BUTTON);
    if (this._btnSolidBgColor !== btnBgColor) {
      this._btnSolidBgColor = btnBgColor;
      this.notifyStateChange(SlCapStaticStPt.PT_BTN_SOLID_BG_COLOR);
    }
    // 主胶囊条目背景颜色
    let mainCapBgColor = this.getSolidColor(SlPositionType.SL_CAP_FIRST_BACKGROUND);
    if (this._mainCapSolidBgColor !== mainCapBgColor) {
      this._mainCapSolidBgColor = mainCapBgColor;
      this.notifyStateChange(SlCapStaticStPt.PT_MAIN_CAP_SOLID_BG_COLOR);
    }
    // 阴影胶囊条目背景颜色
    let shadowCapBgColor = this.getSolidColor(SlPositionType.SL_CAP_SECOND_BACKGROUND);
    if (this._shadowCapSolidBgColor !== shadowCapBgColor) {
      this._shadowCapSolidBgColor = shadowCapBgColor;
      this.notifyStateChange(SlCapStaticStPt.PT_SHADOW_CAP_SOLID_BG_COLOR);
    }
    // 主胶囊条目前景颜色
    let mainCapFgColor = this.getSolidColor(SlPositionType.SL_CAP_FIRST_FOREGROUND);
    if (this._mainCapSolidFgColor !== mainCapFgColor) {
      this._mainCapSolidFgColor = mainCapFgColor;
      this.notifyStateChange(SlCapStaticStPt.PT_MAIN_CAP_SOLID_FG_COLOR);
    }
    // 阴影胶囊条目前景颜色
    let shadowCapFgColor = this.getSolidColor(SlPositionType.SL_CAP_SECOND_FOREGROUND);
    if (this._shadowCapSolidFgColor !== shadowCapFgColor) {
      this._shadowCapSolidFgColor = shadowCapFgColor;
      this.notifyStateChange(SlCapStaticStPt.PT_SHADOW_CAP_SOLID_FG_COLOR);
    }
    // 扩展区文本前景颜色
    let extTextFgColor = this.getSolidColor(SlPositionType.SL_CAP_SUPPORT_TEXT_BRIGHT);
    if (this._extTextSolidFgColor !== extTextFgColor) {
      this._extTextSolidFgColor = extTextFgColor;
      this.notifyStateChange(SlCapStaticStPt.PT_EXT_TEXT_SOLID_FG_COLOR);
    }
    // 扩展区按钮背景颜色
    let extBtnFgColor = this.getSolidColor(SlPositionType.SL_CAP_SUPPORT_BACK_BRIGHT);
    if (this._extBtnSolidBgColor !== extBtnFgColor) {
      this._extBtnSolidBgColor = extBtnFgColor;
      this.notifyStateChange(SlCapStaticStPt.PT_EXT_BTN_SOLID_BG_COLOR);
    }
  }

  private getSolidColor(posType: SlPositionType): ResourceColor | undefined {
    // 对应业务纯色颜色
    return SlVisualControl.getInstance().getVisualArgs(posType)?.getSolidColor();
  }

  private setBtnSolidBgColor(solidStyle: WidgetStyleStateV2): void {
    // 赋值胶囊按钮背景纯色
    solidStyle?.setBgColor(this._btnSolidBgColor);
  }

  private setMainCapSolidBgColor(solidStyle: WidgetStyleStateV2): void {
    // 赋值主胶囊背景纯色
    solidStyle?.setBgColor(this._mainCapSolidBgColor);
  }

  private setShadowCapSolidBgColor(solidStyle: WidgetStyleStateV2): void {
    // 赋值阴影胶囊背景纯色
    solidStyle?.setBgColor(this._shadowCapSolidBgColor);
  }

  private setMainCapSolidFgColor(solidStyle: WidgetStyleStateV2): void {
    // 赋值主胶囊前景纯色
    solidStyle?.setFontColor(this._mainCapSolidFgColor);
  }

  private setShadowCapSolidFgColor(solidStyle: WidgetStyleStateV2): void {
    // 赋值阴影胶囊前景纯色
    solidStyle?.setFontColor(this._shadowCapSolidFgColor);
  }

  private setExtTextSolidFgColor(solidStyle: WidgetStyleStateV2): void {
    // 赋值扩展区文本前景纯色
    solidStyle?.setFontColor(this._extTextSolidFgColor);
  }

  private setExtBtnSolidFgColor(solidStyle: WidgetStyleStateV2): void {
    // 赋值扩展区按钮背景纯色
    solidStyle?.setBgColor(this._extBtnSolidBgColor);
  }
}