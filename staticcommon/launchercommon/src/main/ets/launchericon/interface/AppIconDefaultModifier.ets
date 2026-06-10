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
import { NumberConstants } from '@ohos/commonconstants';
import { CommonConstants } from '../../constants/CommonConstants';
import { MultiSelectStyleConfig } from '../../editmode/data/MultiSelectStyleConfig';
import { AppIconBaseModifier } from './AppIconBaseModifier';
import { AppIconDragEventIface } from './AppIconDragEventIface';
import { AppIconLongPressGestureEventIface } from './AppIconLongPressGestureEventIface';
import { ModifierEventIface } from './ModifierEventIface';
import { ModifierStyleIface } from './ModifierStyleIface';
import { AppIconContextMenuIface } from './AppIconContextMenuIface';
import { AppIconGestureJudgeIface } from './AppIconGestureJudgeIface';
import { AppIconTouchEventIface } from './AppIconTouchEventIface';

const TAG = 'AppIconDefaultModifier';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

export interface AppIconModifierEventParam {
  touchEventIface?: AppIconTouchEventIface;
  dragEventIface?: AppIconDragEventIface;
  gestureJudgeBeginEventIface?: AppIconGestureJudgeIface;
  longPressGestureEventIface?: AppIconLongPressGestureEventIface;
  rightClickContextMenuIface?: AppIconContextMenuIface;
  longPressContextMenuIface?: AppIconContextMenuIface;
}

export class AppIconDefaultModifier extends AppIconBaseModifier implements ModifierStyleIface, ModifierEventIface {
  private touchEventIface?: AppIconTouchEventIface;
  private dragEventIface?: AppIconDragEventIface;
  private gestureJudgeBeginEventIface?: AppIconGestureJudgeIface;
  private longPressGestureEventIface?: AppIconLongPressGestureEventIface;
  private rightClickContextMenuIface?: AppIconContextMenuIface;
  private longPressContextMenuIface?: AppIconContextMenuIface;

  initializeModifier(instance: CommonAttribute): void {
    this.initCommonStyle(instance);
  }

  /**
   * 初始化Icon modifier的事件信息, 因Modifier事件仍然在调试中, 手势相关事件支持度不稳定, 暂不开放覆写
   * 需要在View组件上定义事件, 通过在事件类中覆写对应的回调的方式实现差异化控制
   * @param 图标的touch、drag、longPress等事件接口回调
   */
  public initModifierEventIfaceParam(param?: AppIconModifierEventParam): void {
    if (!param) {
      log.showError('initModifierEventIfaceParam failed, param is invalid!')
      return;
    }

    this.touchEventIface = param.touchEventIface;
    this.dragEventIface = param.dragEventIface;
    this.gestureJudgeBeginEventIface = param.gestureJudgeBeginEventIface;
    this.longPressGestureEventIface = param.longPressGestureEventIface;
    this.rightClickContextMenuIface = param.rightClickContextMenuIface;
    this.longPressContextMenuIface = param.longPressContextMenuIface;
  }

  /**
   * 初始华基本的Style属性参数
   * @param instance
   */
  initCommonStyle(instance: CommonAttribute): void {
    // 此处不要绑定状态变量, 状态变量需要绑定在View上, 重写Modifier 需要注入iconStyleCb
  }

  /**
   * 图标Touch事件, 因Modifier适配未完善, 该接口暂未开启, AppIconCommonView上挂载该事件
   * @param instance
   */
  public initTouchEvent(instance?: CommonAttribute): void {
    instance?.onTouch((event: TouchEvent) => {
      this.touchEventIface?.onTouch(event);
    });
  }

  /**
   * 图标点击事件, 因Modifier适配未完善, 该接口暂未开启, AppIconCommonView上挂载该事件
   * @param instance
   */
  public initClickEvent(instance?: CommonAttribute): void {
    // 因ArkUI调度问题, 长按图标会启动应用, 通过互斥手势来模拟点击事件
    instance?.gesture(
      GestureGroup(GestureMode.Exclusive,
        LongPressGesture(),
        TapGesture()
          .onAction(() => {
            this.touchEventIface?.onClick();
          })
      )
    );
  }

  /**
   * 图标长按事件, 因Modifier适配未完善, 该接口暂未开启, AppIconCommonView上挂载长按事件
   * @param instance
   */
  public initLongPressGestureEvent(instance?: CommonAttribute): void {
    instance?.parallelGesture(
      GestureGroup(GestureMode.Parallel,
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_ZOOM_IN })
          .onAction((event: GestureEvent): void =>
          this.longPressGestureEventIface?.onLongPressZoomInAction(event)),
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_VIBRATOR_TIME })
          .onAction((event: GestureEvent): void => {
            this.longPressGestureEventIface?.onLongPressVibrateAction(event);
          }),
        LongPressGesture({ repeat: false, duration: CommonConstants.LONG_PRESS_TIME_FOR_SNAPSHOT })
          .onAction((event: GestureEvent) => {
            this.longPressGestureEventIface?.onLongPressSnapshotAction(event);
          }),
        LongPressGesture({ repeat: false, duration: MultiSelectStyleConfig.LONG_PRESS_TIME_OF_PRE_GATHER })
          .onAction((event: GestureEvent) => {
            this.longPressGestureEventIface?.onLongPressPreGatherAction(event);
          })
          .onActionEnd((event: GestureEvent) => {
            this.longPressGestureEventIface?.onLongPressPreGatherActionEnd(event);
          }),
        LongPressGesture({ repeat: false, duration: MultiSelectStyleConfig.LONG_PRESS_TIME_OF_GATHER })
          .onAction((event: GestureEvent) => {
            this.longPressGestureEventIface?.onLongPressGatherAction(event);
          })
      ),
    );
  }

  /**
   * 拖拽常用事件, 因Modifier适配未完善, 该接口暂未开启, AppIconCommonView上挂载拖拽事件
   * @param instance
   */
  public initDragEvent(instance?: CommonAttribute): void {
    instance?.onDragStart((event: DragEvent) => {
      this.dragEventIface?.onDragStart(event);
    })
      .onDragEnd((event: DragEvent) => {
        this.dragEventIface?.onDragEnd(event);
      })
      .onPreDrag((preDragStatus: PreDragStatus) => {
        this.dragEventIface?.onPreDrag(preDragStatus);
      })
      .dragPreview(this.dragEventIface?.getDragPreviewBuilder());
  }

  /**
   * 拖拽手势互斥的场景, 可以进行重写; 如果此处不需要走此流程, return GestureJudgeResult.Continue;
   * 因Modifier适配未完善, 该接口暂未开启, AppIconCommonView上挂载该事件
   * @param instance
   */
  public initGestureJudgeBeginEvent(instance?: CommonAttribute | undefined): void {
    instance?.onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
      return this.gestureJudgeBeginEventIface?.onGestureJudgeBegin(gestureInfo, event);
    });
  }

  /**
   * 菜单事件: 包括右键、长按菜单
   * 因Modifier适配未完善, 该接口暂未开启, AppIconCommonView上挂载菜单事件
   * @param instance
   */
  public initMenuEvent(instance?: CommonAttribute): void {
    this.initRightClickMenuEvent(instance);
    this.initLongPressMenuEvent(instance);
  }

  /**
   * 图标右键菜单事件
   * @param instance
   */
  private initRightClickMenuEvent(instance?: CommonAttribute): void {
    if (!instance || !this.rightClickContextMenuIface) {
      log.showError('instance or rightClickContextMenuIface is invalid!');
      return;
    }

    instance.bindContextMenu(this.rightClickContextMenuIface.showContextMenu(),
      this.rightClickContextMenuIface.getContentBuilder(),
      this.rightClickContextMenuIface.getRightClickMenuOptions(Placement.BottomLeft));
  }

  /**
   * 图标长按菜单事件
   * @param instance
   */
  private initLongPressMenuEvent(instance?: CommonAttribute): void {
    if (!instance || !this.longPressContextMenuIface) {
      log.showError('instance or longPressContextMenuIface is invalid!');
      return;
    }

    instance.bindContextMenu(this.longPressContextMenuIface.showContextMenu(),
      this.longPressContextMenuIface.getContentBuilder(),
      this.longPressContextMenuIface.getLongPressMenuOptions());
  }
}