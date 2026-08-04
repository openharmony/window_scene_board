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
import { NtfListKeyGuard } from '@ohos/notificationcomponent/src/main/ets/model/NtfListKeyGuard';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { NotificationConfig } from '@ohos/notificationcomponent/src/main/ets/common/NotificationConfig';
import { NtfCloseVM } from '@ohos/notificationcomponent/src/main/ets/vm/NtfCloseVM';
import { ImmersiveConstants } from '../../common/ImmersiveConstants';
import { immersiveVm } from '../../viewmodel/ImmersiveVm';
import { ImmersiveListVm } from '../../viewmodel/ImmersiveListVm';
import { NotificationEntryArray } from '../../viewmodel/viewdata/NotificationEntryArray';
import { ImmersiveListItem } from './ImmersiveListItem';
import { NtfListBindState, NtfListStaticState } from '../../viewmodel/viewdata/NtfListState';
import { ImmersiveListHandle } from '../../viewmodel/viewevent/ImmersiveListHandle';
import { ImmersiveAnimManager } from '../../viewmodel/viewanim/ImmersiveAnimManager';
import { ImmersiveAnimKey, ImmersivePfmConstant } from '../../common/anim/ImmersiveAnimConstants';
import { performanceMonitor } from '@kit.ArkUI';
import { ArrayUtils } from '@ohos/basicutils';
import {
  SlMainStateType,
  SlStaticStateType,
  SlSubStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { DownPosition, ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import { SlListWidgetBindState } from '../../model/data/SlListWidgetBindState';
import { immersiveStateHelper } from '../../common/helper/ImmersiveStateHelper';
import { ImmersiveAodStyle, immersiveKgMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';

const TAG = 'ImmersiveNtfListComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 沉浸锁屏通知列表组件
 */
@Component
export struct ImmersiveNtfListComponent {
  /**
   * 沉浸列表业务管理
   */
  private listVm: ImmersiveListVm = immersiveVm.getImmersiveListVm();

  /**
   * 沉浸动效管理器
   */
  private animMgr: ImmersiveAnimManager = immersiveVm.getImmersiveAnimMgr();

  /**
   * 事件处理器
   */
  private eventHandle: ImmersiveListHandle = immersiveVm.getImmersiveListHandle();

  /**
   * 沉浸列表静态状态管理
   */
  private staticState: NtfListStaticState = this.listVm.getListStaticState();

  /**
   * 锁屏静态状态
   */
  private slStaticState?: ISlState;
  private slStaticStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === SlStaticStateType.SL_PANEL_DOWN_GLOBAL) {
        this.onScreenLockPanelDownGlobalChange();
      }
    }
  };

  /**
   * UI绑定状态管理
   */
  @State bindState: NtfListBindState = this.listVm.getListBindState();

  /**
   * 锁屏通知，锁屏后收到的通知和ongoing通知
   */
  @State lockScreenNtfList: NotificationEntryArray = this.listVm.getNtfList();

  /**
   * VM，通知数据
   */
  private ntfListVM: NtfListKeyGuard | undefined = undefined;

  /**
   * 记录锁屏时间，用来区分历史消息和锁屏消息
   */
  @Consume lockScreenTime: number;

  /**
   * 记录左滑状态的通知的哈希值，用于左滑状态互斥（同一时刻，只允许一条通知左滑）
   */
  @Provide swipeHashCode: string = '';

  @Prop isNtfFingerprintConflict: boolean;

  /**
   * close按钮VM
   */
  @Provide private closeVM?: NtfCloseVM = undefined;

  // 面板触摸down点，全局Y轴点，-1无触摸
  @Provide panelDownGlobalY: number = -1;

  // 面板触摸down点，全局X轴点，-1无触摸
  @Provide panelDownGlobalX: number = -1;

  /**
   * 记录展示按钮的通知的哈希值，用于互斥操作
   */
  @Provide displayButtonsHashCode: string = '';

  // 锁屏首页通知列表组件状态
  @State slListBindState?: SlListWidgetBindState = immersiveStateHelper.getSlListBindState() as SlListWidgetBindState;

  /**
   * Aod显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(true);

  aboutToAppear(): void {
    log.showInfo('aboutToAppear, start');
    this.listVm.appear(this.ntfListVM);
    this.slStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE);
    slUiStateMgr.registerSlStateChangeListener(this.slStaticStateListener);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.listVm.disappear();
    this.staticState?.updateScrolling(false);
    slUiStateMgr.unregisterSlStateChangeListener(this.slStaticStateListener);
    this.slStaticState = undefined;
  }

  build() {
    if (!ArrayUtils.isEmpty(this.lockScreenNtfList)) {
      List({ scroller: this.listVm.getListScroller(), space: this.staticState.itemSpace }) {
        ForEach(this.lockScreenNtfList, (entry: NotificationEntry, index: number) => {
          ImmersiveListItem({
            ntfEntry: entry,
            ntfAnimParameters: this.bindState.getNtfAnimPara(entry.getGroupKey()),
            animState: this.animMgr.getListAnimState(entry?.getGroupKey()),
            colorModeVM: this.listVm.getColorModeVM()
          })
        }, (entry: NotificationEntry, index: number): string => {
          return ImmersiveConstants.getImmersiveID(entry.getGroupKey());
        })
      }
      .id(TAG)
      .clip(false)
      .alignListItem(ListItemAlign.Center)
      .cachedCount(NotificationConfig.LIST_CACHE_COUNT)
      .width('100%')
      .height(this.bindState.listHeight)
      .contentStartOffset(this.staticState.itemSpace)
      .contentEndOffset(this.staticState.itemSpace)
      .listDirection(Axis.Vertical)
      .scrollBar(BarState.Off)
      .friction(0.6)
      // 禁止滑动时，防止回弹
      .edgeEffect(this.slListBindState?.getListScrollEnable() ? EdgeEffect.Spring : EdgeEffect.None)
      .borderRadius(NotificationConfig.BORDER_RADIUS)
      .enableScrollInteraction(this.slListBindState?.getListScrollEnable() && !this.aodStyle?.isAod)
      .onAppear(() => {
        this.listVm.scrollListToTop(); // 初始化保持置顶
      })
      .onScrollIndex((start: number, end: number, center: number) => {
        this.listVm.updateScrollIndex(start, end);
      })
      .onScrollStart(() => {
        this.eventHandle.scrollStart();
        this.staticState?.updateScrolling(true);
        performanceMonitor.begin(ImmersivePfmConstant.SCENE_LIST_SWIPE_ANIM, performanceMonitor.ActionType.FIRST_MOVE);
      })
      .onScrollStop(() => {
        this.staticState?.updateScrolling(false);
        performanceMonitor.end(ImmersivePfmConstant.SCENE_LIST_SWIPE_ANIM);
      })
      .onReachStart(() => {
        this.eventHandle.scrollReachStartEnd();
      })
      .onReachEnd(() => {
        this.eventHandle.scrollReachStartEnd();
      })
      .onWillScroll((offset: number) => {
        this.eventHandle.scrollFrameBegin(offset);
        return { offsetRemain: offset } as ScrollResult
      })
      .onDidScroll((offset: number) => {
        this.eventHandle.scrollList(0);
      })
      .onTouch((event) => {
        let isEmpty = this.listVm.isListEmpty();
        if (event == undefined || event == null || isEmpty) {
          return;
        }
        if (this.staticState.isStopPropagation) {
          // 有通知 & 需要拦截时，阻止TouchEven冒泡，父控件不会收到onTouch回调
          event.stopPropagation();
        }

        switch (event.type as TouchType) {
          case TouchType.Down:
          // 记录down点
            if (event.touches.length == 1) {
              this.panelDownGlobalY = event.touches[0].screenY;
              this.panelDownGlobalX = event.touches[0].screenX;
            }
            break;
          default:
            break;
        }
        this.eventHandle.onListTouchEvent(event); // 触摸事件处理
      })
      .parallelGesture(GestureGroup(GestureMode.Exclusive,
        PanGesture({ direction: PanDirection.Up })
          .onActionStart((event: GestureEvent) => this.eventHandle.onGestureStart(PanDirection.Up, event))
          .onActionUpdate((event: GestureEvent) => this.eventHandle.onGestureUpdate(PanDirection.Up, event))
          .onActionEnd((event: GestureEvent) => this.eventHandle.onGestureEnd(PanDirection.Up, false, event))
          .onActionCancel(() => this.eventHandle.onGestureEnd(PanDirection.Up, true)),
        PanGesture({ direction: PanDirection.Down })
          .onActionStart((event: GestureEvent) => this.eventHandle.onGestureStart(PanDirection.Down, event))
          .onActionUpdate((event: GestureEvent) => this.eventHandle.onGestureUpdate(PanDirection.Down, event))
          .onActionCancel(() => this.eventHandle.onGestureEnd(PanDirection.Down, true))
          .onActionEnd((event?: GestureEvent) => this.eventHandle.onGestureEnd(PanDirection.Down, false, event)),
        PanGesture({ direction: PanDirection.Left })
          .onActionStart((event: GestureEvent) => this.eventHandle.onGestureStart(PanDirection.Left, event))
          .onActionEnd((event: GestureEvent) => this.eventHandle.onGestureEnd(PanDirection.Left, false, event))
          .onActionCancel(() => this.eventHandle.onGestureEnd(PanDirection.Left, true)),
        PanGesture({ direction: PanDirection.Right })
          .onActionStart((event: GestureEvent) => this.eventHandle.onGestureStart(PanDirection.Right, event))
          .onActionEnd((event: GestureEvent) => this.eventHandle.onGestureEnd(PanDirection.Right, false, event))
          .onActionCancel(() => this.eventHandle.onGestureEnd(PanDirection.Right, true)),
      ))
      .onAreaChange((oldSize: Area, newSize: Area) => {
        this.animMgr.setListViewArea(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT, newSize);
        this.listVm.onListAreaChange(oldSize, newSize);
        this.eventHandle.scrollList(0, true); // 刷新滑动参数
      })
    }
  }

  /**
   * 锁屏面板点击事件回调
   */
  private onScreenLockPanelDownGlobalChange(): void {
    let globalDown = this.slStaticState?.getSlState(SlStaticStateType.SL_PANEL_DOWN_GLOBAL) as DownPosition;
    this.panelDownGlobalX = globalDown.positionX;
    this.panelDownGlobalY = globalDown.positionY;
  }
}
