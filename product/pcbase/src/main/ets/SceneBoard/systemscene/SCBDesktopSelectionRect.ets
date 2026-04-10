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

import {
  CommonConstants,
  GridLayoutConfig,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager
} from '@ohos/launchercommon';
import { BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import type abilityCommon from '@ohos.app.ability.common';
import { PageDesktopViewModel } from '@ohos/pagedesktop';
import { GlobalContext, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper, SingleContext } from '@ohos/basicutils';
import { SCBScreenProperty } from '@ohos/windowscene';
import FeatureConstants from '@ohos/pagedesktop/src/main/ets/default/common/constants/FeatureConstants';

const TAG = 'SCBDesktopSelectionRect';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const UIGHUR = ['ug-CN', 'ug'];

@Component
export struct SCBDesktopSelectionRect {
  @Prop singleContext?: SingleContext;
  @State mouseStartPosition: number[] = [0, 0];
  @State mouseEndPosition: number[] = [0, 0];
  @Link screenProperty: SCBScreenProperty;
  @StorageLink('isDrag') @Watch('updateEnableStates') isDrag: boolean = false;
  @StorageLink('enableDesktopSelect') @Watch('updateEnableStates') enableDesktopSelect: boolean = true;
  @StorageLink('isRectSelecting') isRectSelecting: boolean = false;
  @StorageLink('systemLanguage') systemLanguage: string = '';
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
  private desktopContext?: abilityCommon.ServiceExtensionContext = GlobalContext.getContext();
  private drawSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private drawContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.drawSettings);
  private lineWidth: number = 0.15;
  private selectRectLeftTopPosition: number[] = [0, 0];
  private selectRectRightBottomPosition: number[] = [0, 0];
  private dockTop: number = 0;
  private isPortrait: boolean = true;
  private lastMousePosition: number[] = [0, 0];
  @State leftMousePressed: boolean = false;

  private updateEnableStates(): void {
    log.showInfo(`updateEnableStates isDrag: ${this.isDrag}, enableDesktopSelect: ${this.enableDesktopSelect}`);
    if (this.isDrag || !this.enableDesktopSelect) {
      this.leftMousePressed = false;
      this.resetInitValue();
    }
  }

  private setStartPosition(x: number, y: number): void {
    this.mouseStartPosition = [x, y];
    this.lastMousePosition = [this.mouseStartPosition[0], this.mouseStartPosition[1]];
    this.dockTop = viewMgrPolicy.getArea(ViewType.SMART_DOCK)?.top ?? 0;
    log.info(`Rect bottom line height: dockTop ${this.dockTop}`);
  }

  private calculateRectSize(x: number, y: number): void {
    this.mouseEndPosition = [x, y]
    this.drawRect(this.mouseStartPosition, this.mouseEndPosition);
  }

  private revisePositionY(): number {
    let revisePositionY: number = 0;
    if (this.mPageDesktopViewModel.getKeyBoardStatus() === FeatureConstants.KEYBOARD_PAGE_C) {
      revisePositionY = this.mPageDesktopViewModel.getPageDesktopStyleConfig().mGridHeight +
        this.mPageDesktopViewModel.getPageDesktopStyleConfig().mFoldCreaseRegionHeight;
    }
    return revisePositionY;
  }

  private resetInitValue(): void {
    this.cleanRect();
    this.isRectSelecting = false;
    this.mouseStartPosition = [0, 0];
  }

  private updateDrawRectPosition(startPosition: number[], endPosition: number[]) {
    for (let i = 0; i < startPosition.length; i++) {
      if (startPosition[i] < endPosition[i]) {
        this.selectRectLeftTopPosition[i] = startPosition[i];
        this.selectRectRightBottomPosition[i] = endPosition[i];
      } else {
        this.selectRectLeftTopPosition[i] = endPosition[i];
        this.selectRectRightBottomPosition[i] = startPosition[i];
      }
    }
    // 键盘态，显示C面时，框选左上、右下角坐标位置需增加偏移量
    this.selectRectLeftTopPosition[1] = this.selectRectLeftTopPosition[1] + this.revisePositionY();
    this.selectRectRightBottomPosition[1] = this.selectRectRightBottomPosition[1] + this.revisePositionY();
  }

  private drawRect(startPosition: number[], endPosition: number[]): void {
    this.cleanRect();
    // 限定框选区域在dock上方
    if (this.dockTop > 0 && this.dockTop < endPosition[1]) {
      endPosition[1] = this.dockTop;
    }
    this.updateDrawRectPosition(startPosition, endPosition);
    // 注：宽高可以为负数，当为负数时，是向反方向画矩形。strokeRect为边框，fillRect为填充物
    const width: number = endPosition[0] - startPosition[0];
    const height: number = endPosition[1] - startPosition[1];
    // 键盘态，显示C面时，框选阴影的显示也需增加偏移量
    this.drawContext.strokeRect(startPosition[0], startPosition[1] + this.revisePositionY(), width, height);
    this.drawContext.fillRect(startPosition[0], startPosition[1] + this.revisePositionY(),
      width - this.lineWidth, height - this.lineWidth);
  }

  private cleanRect(): void {
    // 清理画布时，直接使用较大值清理。若使用屏幕宽高清理，当有扩展屏或其他因素导致屏幕宽高计算有误时，会导致画布无法清理干净。
    this.drawContext.clearRect(0, 0, 100000, 100000);
  }

  private updateSelectItem(): void {
    const itemList: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance()
      .getAllGridLayoutItemList(BusinessType.BUSINESS_APP);
    let selectItemList: string[] = [];
    this.mPageDesktopViewModel.onSelectItemChange(selectItemList, true);
    AppStorage.setOrCreate('selectedItemList', selectItemList);
  }

  private handleItemSelectState(gridItem: GridLayoutItemInfo, isSelect: boolean): void {
    this.desktopContext?.eventHub.emit(this.getDesktopRectSelectItemEventKey(gridItem), isSelect);
  }

  private getDesktopRectSelectItemEventKey(item: GridLayoutItemInfo): string {
    return 'DesktopRectSelectItemEvent_' + GridLayoutUtil.generateUniqueKey(item);
  }

  getHotArea(): number[] {
    let hotArea: number[] = [];
    hotArea[0] = this.selectRectLeftTopPosition[0];
    hotArea[1] = this.selectRectLeftTopPosition[1];
    hotArea[2] = this.selectRectRightBottomPosition[0];
    hotArea[3] = this.selectRectRightBottomPosition[1];
    const screenWidth: number = this.getUIContext()?.px2vp(this.screenProperty.width);
    if (UIGHUR.includes(this.systemLanguage)) {
      hotArea[0] = screenWidth - this.selectRectRightBottomPosition[0];
      hotArea[2] = screenWidth - this.selectRectLeftTopPosition[0];
    }
    return hotArea;
  }

  private isItemSelected(itemLeftTopPos: number[], itemRightBottomPos: number[]): boolean {
    const hotArea = this.getHotArea();
    // 当图标整体在框选区域的上，下，左，右侧时，表示未被选中。
    if (itemRightBottomPos[1] < hotArea[1] || itemLeftTopPos[1] > hotArea[3] ||
      itemRightBottomPos[0] < hotArea[0] || itemLeftTopPos[0] > hotArea[2]) {
      return false;
    }
    return true;
  }

  private updateRectSelectState(): void {
    const moveDistance: number = Math.sqrt(
      Math.pow(this.mouseEndPosition[0] - this.lastMousePosition[0], 2) +
      Math.pow(this.mouseEndPosition[1] - this.lastMousePosition[1], 2));
    if (moveDistance > 10) {
      if (!this.isRectSelecting) {
        this.startRectSelectDataUpdate();
      }
      this.lastMousePosition = [this.mouseEndPosition[0], this.mouseEndPosition[1]];
      this.updateSelectItem();
    }
  }

  private startRectSelectDataUpdate(): void {
    log.showInfo('Rect Selecting');
    this.isRectSelecting = true;
    this.isPortrait = AppStorage.get<boolean>('isPortrait') as boolean;
  }

  private handleMousePressEvent(event: MouseEvent): void {
    this.resetInitValue();
    this.setStartPosition(event.windowX, event.windowY);
  }

  private handleMouseMoveEvent(event: MouseEvent): void {
    log.showInfo(`handleMouseMoveEvent isDrag: ${this.isDrag}, enableDesktopSelect: ${this.enableDesktopSelect},
      multiDrag: ${this.mPageDesktopViewModel.getMultiDragStart()}`);
    if (this.isDrag || !this.enableDesktopSelect || this.mPageDesktopViewModel.getMultiDragStart()) {
      log.showWarn('intercept rect select');
      this.isRectSelecting = false;
      return;
    }
    this.calculateRectSize(event.windowX, event.windowY);
    this.updateRectSelectState();
  }

  private handleMouseReleaseEvent(event: MouseEvent): void {
    log.showInfo('handleMouseReleaseEvent');
    this.resetInitValue();
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    AppStorage.setOrCreate('isRectSelecting', false);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisAppear');
  }

  build() {
    Stack() {
      Canvas(this.drawContext)
        .width('100%')
        .height('100%')
        .onReady(() => {
          this.drawContext.lineWidth = this.lineWidth * 2;
          this.drawContext.strokeStyle = '#AAFFFFFF';
          this.drawContext.fillStyle = '#18000000';
        })
        .onAppear(() => {
          log.showInfo('Canvas onAppear');
        })
        .onDisAppear(() => {
          log.showInfo('Canvas onDisAppear');
        })
        .visibility(this.leftMousePressed ? Visibility.Visible : Visibility.Hidden)
    }
    .width('100%')
    .height('100%')
    .focusable(false)
    .draggable(false)
    .hitTestBehavior(HitTestMode.Transparent)
    .onMouse((event: MouseEvent) => {
      if (event.button === MouseButton.Left) {
        if (event.action === MouseAction.Press) {
          this.leftMousePressed = true;
          this.handleMousePressEvent(event);
        }
        if (event.action === MouseAction.Move && this.leftMousePressed) {
          this.handleMouseMoveEvent(event);
        }
        if (event.action === MouseAction.Release) {
          this.leftMousePressed = false;
          this.handleMouseReleaseEvent(event);
        }
      }
    })
  }
}