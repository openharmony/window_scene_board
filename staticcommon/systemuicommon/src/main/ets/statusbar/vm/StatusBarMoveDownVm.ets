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
import { Trace as TraceTest } from '@ohos/basicutils';
import { CutoutEvent, DeviceHelper, DropDownEvent, ViewArea } from '@ohos/frameworkwrapper';
import DropDownPanelManager from '../../manager/DropDownPanelManager';
import { StatusBarType } from '../../plugin/info/StatusBarType';
import { curves, display } from '@kit.ArkUI';
import { StatusBarHeightVm } from '../../statusbar/vm/StatusBarHeightVm';
import { lockIconForOuterHome } from '../enum/StatusbarConstants';
import { deviceInfo } from '@kit.BasicServicesKit';
import { EnvVm } from '../../vm/EnvVm';
import { CutoutVm } from './CutoutVm';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { ArkUIAdapter } from '../../utils/ArkUIAdapter';
import { DropdownVm } from '../../vm/DropdownVm';

const TAG = 'StatusBarMoveDownVm'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const STATUS_BAR_HEIGHT: number = 24;
const MOVE_SCALE: number = 0.35;
const SAFE_AREA_DIS: number = 4;
const IS_COMPACT_LAYOUT: boolean = ['PLR', 'PLA', 'PLU'].includes(deviceInfo.productSeries);
const MOVE_STATE_CHANGE_MAX_TIME = 700;

export class StatusBarMoveDownVm {
  protected dropDownEvent: DropDownEvent = DropDownPanelManager.getDropDownEvent();
  private smallWindowWidth: number = 600; // 状态栏是否下沉的判定界限宽度 单位VP
  private screenWidth: number = 0;
  private screenHeight: number = 0;
  private startMoveState: boolean = false;
  private checkTimerID: number = -1;
  private curStatusBarType: StatusBarType = StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;
  private moveKeepOffset: number = 0; // 状态栏下沉的默认位置
  private orientation: number = 0;
  private curCutoutEvent: CutoutEvent = new CutoutEvent();
  public isMoveDown: boolean = false;
  public defaultTopPadding: number = 0; // 状态栏无挖孔信息时的默认显示位置
  public moveDefaultTopPadding: number = 0; // 状态栏依据挖孔计算出来的TopPadding
  public statusBarCenterY: number = 0; // 状态栏依据挖孔TopPadding计算出来的水平中心位置
  public curMoveDis: number = 0;
  private avoidHeight: number = 0;
  public showHeight: number = 100;
  public fakeLightShow: boolean = false;
  private foldDisplayMode: display.FoldDisplayMode = display.getFoldDisplayMode();

  private checkShowIcon(): void {
    if (!this.checkNeedMoveDown()) {
      this.isMoveDown = false; // 不下沉的设备，不存在 isMoveDown
    } else if (this.curMoveDis >= this.moveKeepOffset) {
      this.isMoveDown = true;
    } else {
      this.isMoveDown = false;
    }
  }

  /**
   * 刷新状态栏显示位置和下沉位置
   */
  private refreshKeepDistance() {
      // 有挖孔时 基于挖孔计算状态栏 下沉位置、显示位置、显示最大高度数据
      if (this.curCutoutEvent?.cutoutRect?.height > 0 &&
        this.curCutoutEvent?.cutoutRect?.top < STATUS_BAR_HEIGHT && this.curCutoutEvent?.cutoutRect?.top > 0) {
        if (this.orientation === 0) {
          this.computeProperty(this.curCutoutEvent.cutoutRect.height, this.curCutoutEvent.cutoutRect.top);
        }
      } else {
        this.moveKeepOffset = 0;
      }

    log.showInfo(`refreshKeepDistance ${this.moveKeepOffset} ${this.showHeight}`);
    this.checkShowIcon();
  }

  private computeProperty(height: number, top: number): void {
    const extraOffset: number = IS_COMPACT_LAYOUT ? 5 : 0;
    // 状态栏下沉的默认偏移量（挖孔高度 + 状态栏高度）/ 2 状态栏移动到挖孔下侧的距离 + SAFE_AREA_DIS（4VP UX设计规范预留4VP安全边距）
    this.moveKeepOffset = (height + STATUS_BAR_HEIGHT) / 2 + SAFE_AREA_DIS - extraOffset;
    this.moveDefaultTopPadding = (height - STATUS_BAR_HEIGHT) / 2 + top;
    this.statusBarCenterY = STATUS_BAR_HEIGHT / 2 + this.moveDefaultTopPadding;
    // 最大显示高度 = 状态栏显示的默认位置的TopPadding + 下沉时偏移距离 + 状态栏高度 + SAFE_AREA_DIS
    this.showHeight = this.moveDefaultTopPadding + this.moveKeepOffset + STATUS_BAR_HEIGHT + SAFE_AREA_DIS;
  }

  /**
   * 刷新挖孔信息
   */
  public refreshCutout(event: CutoutEvent) {
    log.showInfo(`refreshCutout ${event?.cutoutRect?.top} ${event?.cutoutRect?.width} ${event?.cutoutRect?.left}`)
    if (event) {
      this.curCutoutEvent = event;
    }
    this.refreshKeepDistance()
    this.checkAndForceMoveDown();
  }

  /**
   * 获取状态栏顶部间距
   */
  public getTopPadding(): number {
    if (this.moveDefaultTopPadding <= 0) {
      return this.defaultTopPadding;
    }
    return this.moveDefaultTopPadding;
  }

  /**
   * 开始跟手
   */
  public startMoveDown(): void {
    if (!this.checkNeedMoveDown()) {
      return;
    }
    log.showInfo(`startMoveDown`);
    this.startMoveState = true;
    this.checkShowIcon();
    this.clearTimer();
  }

  /**
   * 跟手移动
   */
  public refreshMoveDisByDropDown(moveY: number): void {
    if (!this.startMoveState || !this.checkNeedMoveDown() || this.screenHeight < 0) {
      return;
    }
    const scaleMoveY = moveY * 0.4;
    if (this.curMoveDis === 0 && scaleMoveY > 0) {
      // 下拉有移动距离后再设置状态栏高度
      StatusBarHeightVm.getInstance().preSetShowHeight(this.showHeight, TAG);
    }
    if (scaleMoveY <= this.moveKeepOffset) {
      // 小于等于 moveKeepOffset 时较快的下拉跟手
      this.curMoveDis = scaleMoveY;
    } else {
      this.updateExtraDistance(scaleMoveY);
    }
    this.checkShowIcon();
  }

  /**
   * 状态栏在下沉到指定位置之后额外下沉距离的计算
   */
  public updateExtraDistance(moveY: number) {
    if (this.curMoveDis === 0) {
      return;
    }
    if (moveY > 0 && this.screenHeight > 0) {
      this.curMoveDis = this.moveKeepOffset + STATUS_BAR_HEIGHT * (Math.min(moveY / this.screenHeight, 1)) * MOVE_SCALE;
    }
  }

  /**
   * 结束额外下沉距离时，状态栏恢复到下沉默认位置
   */
  public endExtraMove() {
    if (this.isMoveDown) {
      this.keepMoveDown();
    }
  }

  /**
   * 结束跟手
   */
  public endMoveDown(): void {
    if (!this.checkNeedMoveDown() || !this.startMoveState) {
      return;
    }
    log.showInfo(`endMoveDown`);
    this.startMoveState = false;
    if (this.dropDownEvent.progress < 1) {
      this.resetMoveDown(); // 下拉未成功，回到原位
    } else {
      this.keepMoveDown(); // 下拉成功，状态栏停留在 下沉的位
    }
  }

  /**
   * 状态栏回到原位
   */
  public resetMoveDown(): void {
    if (!this.checkNeedMoveDown() || this.startMoveState) { // 用户下拉未结束，不能提前重置
      return;
    }
    log.showInfo(`resetMoveDown`);
    this.checkStatusBarHeight();
    if (this.curMoveDis != 0) {
      animateTo({
        curve: Curve.Friction,
        duration: 400,
      }, () => {
        this.curMoveDis = 0;
      })
      this.checkShowIcon();
    }
  }

  /**
   * 状态栏在下沉位停留
   */
  private keepMoveDown(): void {
    if (!this.checkNeedMoveDown()) {
      return;
    }
    const targetDIs: number = this.getMoveKeepOffset();
    this.checkStatusBarHeight();
    if (targetDIs != this.curMoveDis) {
      log.showInfo(`keepMoveDown`)
      StatusBarHeightVm.getInstance().preSetShowHeight(this.showHeight, TAG);
      animateTo({
        curve: Curve.Friction,
        duration: 400,
        onFinish: () => {
          this.checkShowIcon();
        }
      }, () => {
        this.curMoveDis = targetDIs;
      })
    }
  }

  /**
   * 获取下沉保持的距离 单位VP
   */
  public getMoveKeepOffset(): number {
    if (!this.checkNeedMoveDown()) {
      return 0; // 对于需要归位的场景，下沉后状态回到原位。
    }
    return this.moveKeepOffset;
  }

  /**
   * 改变状态栏显示类型，用于外部改变状态栏的显示类型。
   */
  public changeStatusBarType(statusbarType: StatusBarType): void {
    this.curStatusBarType = statusbarType;
    if (this.curStatusBarType === StatusBarType.TYPE_MAIN_PHONE_DROPDOWN) {
      this.keepMoveDown();
    } else {
      this.resetMoveDown();
    }
  }

  private checkStatusBarHeight() {
    this.clearTimer()
    if (this.startMoveState) { // 用户下拉未结束，不能触发
      return;
    }
    this.checkTimerID = setTimeout(() => {
      this.doMoveDownWithoutAnimation('timer');
    }, MOVE_STATE_CHANGE_MAX_TIME);
  }

  private doMoveDownWithoutAnimation(tag: string) {
    if (this.startMoveState) {
      return;
    }
    if (this.curStatusBarType === StatusBarType.TYPE_MAIN_PHONE_DROPDOWN) {
      // 切换未下拉状态栏的时候 状态栏显示高度立即更新
      log.showInfo(`${tag} preSetShowHeight`);
      StatusBarHeightVm.getInstance().preSetShowHeight(this.showHeight, TAG);
      this.curMoveDis = this.getMoveKeepOffset();
    } else {
      log.showInfo(`${tag} clearShowHeight`);
      StatusBarHeightVm.getInstance().clearShowHeight(TAG);
      this.curMoveDis = 0;
    }
    this.checkShowIcon();
  }

  private clearTimer() {
    if (this.checkTimerID >= 0) {
      log.showInfo(`clearTimeout`);
      clearTimeout(this.checkTimerID);
      this.checkTimerID = -1
    }
  }

  /**
   * @param screenWidth 屏幕宽度变化
   */
  public changeScreenWidth(screenWidth: number, screenHeight: number, orientation: number): void {
    this.screenWidth = screenWidth;
    this.screenHeight = screenHeight;
    this.orientation = orientation;
    this.refreshKeepDistance();
    this.checkShowIcon();
    this.checkAndForceMoveDown();
  }

  /**
   * 检查是否需要强制下沉（某些场景下拉面板存在，仍然可以通过连接车机等方式强制旋转屏幕，此时旋转后需要检查是否需要强制下沉）
   */
  private checkAndForceMoveDown() {
    if (this.checkNeedMoveDown()) {
      if (DropdownVm.instance.isDropdownOnly) {
        this.doMoveDownWithoutAnimation('checkAndForceMoveDown');
        return;
      }

      if (this.dropDownEvent.progress < 1) {
        this.resetMoveDown(); // 下拉未成功，回到原位
      } else {
        this.keepMoveDown(); // 下拉成功，状态栏停留在 下沉的位置
      }
    }
  }

  /**
   * 设置当前屏幕显示模式
   */
  public setFoldDisplayMode(foldDisplayMode: display.FoldDisplayMode): void {
    this.foldDisplayMode = foldDisplayMode;
  }

  /**
   * 当前设备是否需要下沉
   * @returns
   */
  public checkNeedMoveDown(): boolean {
    let needMoveDown: boolean = true;
    // 设备宽度
    if (this.screenWidth > this.smallWindowWidth || this.moveKeepOffset <= 0) {
      needMoveDown = false;
    }
    if (!needMoveDown && this.curMoveDis > 0) {
      this.curMoveDis = 0;
      this.isMoveDown = false;
      StatusBarHeightVm.getInstance().clearShowHeight(TAG);
    }
    return needMoveDown;
  }

  public changeAvoidInfo(avoidHeight: number): void {
    // 基于状态栏高度计算状态栏显示的默认位置
    this.avoidHeight = avoidHeight;
    // 默认状态栏是居中显示
    this.defaultTopPadding = Math.max((this.avoidHeight - STATUS_BAR_HEIGHT) / 2, 0)
    if (this.statusBarCenterY === 0) {
      this.statusBarCenterY = STATUS_BAR_HEIGHT / 2 + this.defaultTopPadding;
    }
    log.showInfo(`changeAvoidInfo ${this.defaultTopPadding}`)
  }
}

@ObservedV2
export class StatusBarMoveDownVmV2 extends StatusBarMoveDownVm {
  private static instance?: StatusBarMoveDownVmV2 = undefined;
  @Trace public curMoveDis: number = 0;
  @Trace public isMoveDown: boolean = false;
  @Trace public fakeLightShow: boolean = false;
  private envVm = EnvVm.instance;
  private cutoutVm = CutoutVm.instance;
  private deviceInfoVm = DeviceInfoVm.instance;

  constructor() {
    super();
    const cutoutRect: ViewArea = {
      left: this.cutoutVm.left,
      top: this.cutoutVm.top,
      width: this.cutoutVm.width,
      height: this.cutoutVm.height
    }
    log.showInfo(`init cutoutRect ${cutoutRect.left} ${cutoutRect.top} ${cutoutRect.width} ${cutoutRect.height}`);
    // 刷新下沉挖孔信息
    this.refreshCutout(CutoutEvent.create(0, cutoutRect));
    this.changeScreenWidth(ArkUIAdapter.px2vp(this.deviceInfoVm.width), ArkUIAdapter.px2vp(this.deviceInfoVm.height),
      this.deviceInfoVm.orientation);
  }

  @Monitor('cutoutVm.left', 'cutoutVm.top', 'cutoutVm.width', 'cutoutVm.height')
  onCutoutChange() {
    const cutoutRect: ViewArea = {
      left: this.cutoutVm.left,
      top: this.cutoutVm.top,
      width: this.cutoutVm.width,
      height: this.cutoutVm.height
    }
    log.showInfo(`onCutoutChange cutoutRect ${cutoutRect.left} ${cutoutRect.top} ${cutoutRect.width} ${cutoutRect.height}`);
    // 刷新下沉挖孔信息
    this.refreshCutout(CutoutEvent.create(0, cutoutRect));
  }

  @Monitor('deviceInfoVm.width', 'deviceInfoVm.height', 'deviceInfoVm.orientation')
  onDeviceInfoChange() {
    log.showInfo(`onDeviceInfoChange deviceinfo ${this.deviceInfoVm.width} ${this.deviceInfoVm.height}`);
    this.changeScreenWidth(ArkUIAdapter.px2vp(this.deviceInfoVm.width), ArkUIAdapter.px2vp(this.deviceInfoVm.height),
      this.deviceInfoVm.orientation);
  }

  static getInstance(): StatusBarMoveDownVmV2 {
    if (StatusBarMoveDownVmV2.instance === undefined) {
      StatusBarMoveDownVmV2.instance = new StatusBarMoveDownVmV2();
    }
    return StatusBarMoveDownVmV2.instance;
  }
}

@Observed
export class StatusBarMoveDownVmV1 extends StatusBarMoveDownVm {
  private static instance?: StatusBarMoveDownVmV1 = undefined;
  public isMoveDown: boolean = false;

  static getInstance(): StatusBarMoveDownVmV1 {
    if (StatusBarMoveDownVmV1.instance === undefined) {
      StatusBarMoveDownVmV1.instance = new StatusBarMoveDownVmV1();
    }
    return StatusBarMoveDownVmV1.instance;
  }
}