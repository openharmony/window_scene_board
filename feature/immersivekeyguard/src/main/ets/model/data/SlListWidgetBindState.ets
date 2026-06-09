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

import { ArrayUtils } from '@ohos/basicutils';
import { WidgetBindState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { ListWgBindStateType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { BlurFreezeScene } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';

const DEFAULT_FREEZE_SCENE = 'default_freeze_scene';

/**
 * 锁屏组件，通知列表组件UI绑定状态
 *
 */
@Observed
export class SlListWidgetBindState extends WidgetBindState<ListWgBindStateType> {
  /**
   * 背景模糊冻结场景
   */
  @Track private bgBlurFreezeScene: Set<string> = new Set();
  /**
   * 当前是否背景模糊冻结
   */
  @Track private isBgBlurFreeze: boolean = false;
  /**
   * 列表滚动是否开启
   */
  @Track private isScrollEnable: boolean = true;
  /**
   * 列表显示区域
   */
  @Track private listShowArea: Area | undefined = undefined;
  /**
   * 通知列表的最大高度
   */
  @Track private notificationListHeightMax: number = 0;

  constructor() {
    super(SlMainStateType.SL_LIST_WG_BIND_STATE);
  }

  /**
   * 复写WidgetBindState
   *
   */
  protected initSetMethods(): void {
    super.initSetMethods();
    this.setMethods.set(ListWgBindStateType.BG_BLUR_FREEZE, this.setMethodBgBlurFreeze);
    this.setMethods.set(ListWgBindStateType.SCROLL_ENABLE, this.setMethodListScrollEnable);
    this.setMethods.set(ListWgBindStateType.SHOW_AREA, this.setMethodListArea);
    this.setMethods.set(ListWgBindStateType.NTF_LIST_ITEM_HEIGHT_MAX, this.setMethodListHeightMax);
  }

  private setMethodBgBlurFreeze(st: SlListWidgetBindState, value?: BlurFreezeScene): void {
    st.setBgBlurFreeze(value);
  }

  private setMethodListScrollEnable(st: SlListWidgetBindState, value?: boolean): void {
    st.setListScrollEnable(value);
  }

  private setMethodListArea(st: SlListWidgetBindState, value?: Area): void {
    st.setArea(value);
  }

  private getMethodBgBlurSceneFreeze(st: SlListWidgetBindState, scene?: string): boolean {
    return st.isBgBlurSceneFreeze(scene);
  }

  private getMethodListScrollEnable(st: SlListWidgetBindState): boolean {
    return st.getListScrollEnable();
  }

  private getMethodListArea(st: SlListWidgetBindState): Area | undefined {
    return st.getArea();
  }

  private setMethodListHeightMax(st: SlListWidgetBindState, value: number): void {
    st.setListHeightMax(value);
  }

  private getMethodListHeightMax(st: SlListWidgetBindState): number {
    return st.getListHeightMax();
  }

  /**
   * 复写WidgetBindState
   *
   */
  protected initGetMethods(): void {
    super.initGetMethods();
    this.getMethods.set(ListWgBindStateType.BG_BLUR_FREEZE, this.getMethodBgBlurSceneFreeze);
    this.getMethods.set(ListWgBindStateType.SCROLL_ENABLE, this.getMethodListScrollEnable);
    this.getMethods.set(ListWgBindStateType.SHOW_AREA, this.getMethodListArea);
    this.getMethods.set(ListWgBindStateType.NTF_LIST_ITEM_HEIGHT_MAX, this.getMethodListHeightMax);
  }

  /**
   * 设置模糊冻结状态
   *
   */
  public setBgBlurFreeze(freeze?: BlurFreezeScene): SlListWidgetBindState {
    let isFreeze = freeze?.isFreeze ?? false;
    let scene = freeze?.scene ?? DEFAULT_FREEZE_SCENE;
    if (isFreeze) {
      this.bgBlurFreezeScene.add(scene);
    } else {
      this.bgBlurFreezeScene.delete(scene);
    }
    let isCurFreeze = !ArrayUtils.isEmpty(this.bgBlurFreezeScene);
    if (this.isBgBlurFreeze !== isCurFreeze) {
      this.isBgBlurFreeze = isCurFreeze;
      this.notifyStateChange(ListWgBindStateType.BG_BLUR_FREEZE);
    }
    return this;
  }

  /**
   * 当前模糊冻结状态
   *
   */
  public isBgBlurSceneFreeze(scene?: string): boolean {
    if (scene) {
      return this.bgBlurFreezeScene.has(scene);
    }
    // 无场景，表示全场景检验
    return this.isBgBlurFreeze;
  }

  /**
   * 设置列表滚动使能状态
   */
  public setListScrollEnable(isScrollEnable?: boolean): SlListWidgetBindState {
    if (isScrollEnable !== this.isScrollEnable) {
      this.isScrollEnable = isScrollEnable ?? true;
    }
    return this;
  }

  /**
   * 获取列表滚动使能状态
   */
  public getListScrollEnable(): boolean {
    return this.isScrollEnable;
  }

  /**
   * 设置列表显示区域
   */
  public setArea(listShowArea?: Area): SlListWidgetBindState {
    if (listShowArea !== this.listShowArea) {
      this.listShowArea = listShowArea;
      this.notifyStateChange(ListWgBindStateType.SHOW_AREA)
    }
    return this;
  }

  /**
   * 获取列表显示区域
   */
  public getArea(): Area | undefined {
    return this.listShowArea;
  }

  /**
   * 设置列表最大高度
   */
  public getListHeightMax(): number {
    return this.notificationListHeightMax;
  }

  /**
   * 获取列表最大高度
   */
  public setListHeightMax(notificationListHeightMax: number): SlListWidgetBindState {
    if (this.notificationListHeightMax !== notificationListHeightMax) {
      this.notificationListHeightMax = notificationListHeightMax;
      this.notifyStateChange(ListWgBindStateType.NTF_LIST_ITEM_HEIGHT_MAX);
    }
    return this;
  }
}