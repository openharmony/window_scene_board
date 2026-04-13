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

import { ArrayUtils } from '@ohos/basicutils';
import { SlMainStateType, ClockAnimStateType } from '../constants/SlStateType';
import { ISlState, SlObject } from '../interface/ISlState';
import { ISlStateChangeListener } from '../interface/ISlStateChangeListener';

const DEFAULT_ANIM_SCENE = 'default_anim_scene'; // 默认动效场景

/**
 * 锁屏面板时钟组件动效状态，废弃
 * @deprecated
 */
@Observed
export class ClockAnimState implements ISlState {
  @Track public slStateChangeListener?: ISlStateChangeListener; // 复写ISlState，状态切换监听器
  @Track public widgetStateChangeListener?: ISlStateChangeListener; // 适配时钟组件化状态切换监听器
  @Track private setMethods: Map<ClockAnimStateType, Function> = new Map(); // 状态赋值函数
  @Track private getMethods: Map<ClockAnimStateType, Function> = new Map(); // 状态取值函数
  @Track private isAnimating: boolean = false; // 当前是否动效中
  @Track private tranY?: number; // 竖向位移
  @Track private scaleX?: number; // 横向缩放
  @Track private scaleY?: number; // 竖向缩放
  @Track private opacity?: number; // 时钟整体透明度
  @Track private animScene: Set<string> = new Set(); // 当前动效场景集

  constructor() {
    this.initSetMethods();
    this.initGetMethods();
  }

  private setMethodAddAnimScene(state: ClockAnimState, scene?: string): void {
    state?.addAnimScene(scene);
  }

  private setMethodRemoveAnimScene(state: ClockAnimState, scene?: string): void {
    state?.removeAnimScene(scene);
  }

  private setMethodTranY(state: ClockAnimState, tranY?: number): void {
    state?.setTranY(tranY);
  }

  private setMethodScaleX(state: ClockAnimState, scaleX?: number): void {
    state?.setScaleX(scaleX);
  }

  private setMethodScaleY(state: ClockAnimState, scaleY?: number): void {
    state?.setScaleY(scaleY);
  }

  private setMethodClearAll(state: ClockAnimState): void {
    state?.clearAll();
  }

  private initSetMethods(): void { // 赋值函数统一管理
    this.setMethods.set(ClockAnimStateType.ADD_ANIM_SCENE, this.setMethodAddAnimScene);
    this.setMethods.set(ClockAnimStateType.REMOVE_ANIM_SCENE, this.setMethodRemoveAnimScene);
    this.setMethods.set(ClockAnimStateType.TRAN_Y_STATE, this.setMethodTranY);
    this.setMethods.set(ClockAnimStateType.SCALE_X_STATE, this.setMethodScaleX);
    this.setMethods.set(ClockAnimStateType.SCALE_Y_STATE, this.setMethodScaleY);
    this.setMethods.set(ClockAnimStateType.CLEAR_ALL, this.setMethodClearAll);
    this.setMethods.set(ClockAnimStateType.ALPHA_STATE, this.setOpacity);
  }

  private getMethodIsCurAnimating(st: ClockAnimState): boolean {
    return st.isCurAnimating();
  }

  private getMethodIsSceneAnimating(st: ClockAnimState, scene?: string): boolean {
    return st.isSceneAnimating(scene);
  }

  private getMethodTranY(st: ClockAnimState): number | undefined {
    return st.getTranY();
  }

  private getMethodScaleX(st: ClockAnimState): number | undefined {
    return st.getScaleX();
  }

  private getMethodScaleY(st: ClockAnimState): number | undefined {
    return st.getScaleY();
  }

  private initGetMethods(): void { // 取值函数统一管理
    this.getMethods.set(ClockAnimStateType.IS_ANIMATING, this.getMethodIsCurAnimating);
    this.getMethods.set(ClockAnimStateType.IS_SCENE_ANIMATING, this.getMethodIsSceneAnimating);
    this.getMethods.set(ClockAnimStateType.TRAN_Y_STATE, this.getMethodTranY);
    this.getMethods.set(ClockAnimStateType.SCALE_X_STATE, this.getMethodScaleX);
    this.getMethods.set(ClockAnimStateType.SCALE_Y_STATE, this.getMethodScaleY);
    this.getMethods.set(ClockAnimStateType.ALPHA_STATE, this.getOpacity);
  }

  private notifyStateChange(subType: ClockAnimStateType): void { // 通知状态切换
    this.slStateChangeListener?.onSlStateChange?.(SlMainStateType.CLOCK_ANIM_STATE, subType);
    this.widgetStateChangeListener?.onSlStateChange?.(SlMainStateType.CLOCK_ANIM_STATE, subType);
  }

  private checkAnimState(): void { // 检测当前动效运行状态
    let isCurAnimating = !ArrayUtils.isEmpty(this.animScene);
    if (this.isAnimating !== isCurAnimating) {
      this.isAnimating = isCurAnimating;
      this.notifyStateChange(ClockAnimStateType.IS_ANIMATING);
    }
  }

  public getSlStateType(): SlMainStateType { // 复写ISlState
    return SlMainStateType.CLOCK_ANIM_STATE;
  }

  public setSlState(subType: ClockAnimStateType, value: SlObject): ClockAnimState { // 复写ISlState
    this.setMethods.get(subType)?.(this, value);
    return this;
  }

  public getSlState(subType: ClockAnimStateType, scene?: SlObject): SlObject { // 复写ISlState
    return this.getMethods.get(subType)?.(this, scene);
  }

  public addAnimScene(scene?: string): ClockAnimState { // 添加动效场景
    let animScene = scene ?? DEFAULT_ANIM_SCENE;
    if (!this.animScene.has(animScene)) {
      this.animScene.add(animScene);
      this.notifyStateChange(ClockAnimStateType.IS_SCENE_ANIMATING);
      this.checkAnimState();
    }
    return this;
  }

  public removeAnimScene(scene?: string): ClockAnimState { // 移除动效场景
    let animScene = scene ?? DEFAULT_ANIM_SCENE;
    if (this.animScene.delete(animScene)) {
      this.notifyStateChange(ClockAnimStateType.IS_SCENE_ANIMATING);
      this.checkAnimState();
    }
    return this;
  }

  public isCurAnimating(): boolean { // 当前是否动画中
    return this.isAnimating;
  }

  public isSceneAnimating(scene?: string): boolean { // 当前是否目标场景动效中
    let animScene = scene ?? DEFAULT_ANIM_SCENE;
    return this.animScene.has(animScene);
  }

  public setTranY(tran?: number): ClockAnimState { // 设置竖向位移
    if (this.tranY !== tran) {
      this.tranY = tran;
      this.notifyStateChange(ClockAnimStateType.TRAN_Y_STATE);
    }
    return this;
  }

  public getTranY(): number | undefined { // 竖向位移
    return this.tranY;
  }

  public setScaleX(scale?: number): ClockAnimState { // 设置横向缩放
    if (this.scaleX !== scale) {
      this.scaleX = scale;
      this.notifyStateChange(ClockAnimStateType.SCALE_X_STATE);
    }
    return this;
  }

  public getScaleX(): number | undefined { // 横向缩放
    return this.scaleX;
  }

  public setScaleY(scale?: number): ClockAnimState { // 设置竖向缩放
    if (this.scaleY !== scale) {
      this.scaleY = scale;
      this.notifyStateChange(ClockAnimStateType.SCALE_Y_STATE);
    }
    return this;
  }

  public getScaleY(): number | undefined { // 竖向缩放
    return this.scaleY;
  }

  public setOpacity(opacity?: number): ClockAnimState { // 设置透明度
    if (this.opacity !== opacity) {
      this.opacity = opacity;
      this.notifyStateChange(ClockAnimStateType.ALPHA_STATE);
    }
    return this;
  }

  public getOpacity(): number | undefined { // 透明度
    return this.opacity;
  }

  public clearAll(): ClockAnimState { // 清空动效属性
    return this.setTranY().setScaleX().setScaleY().setOpacity();
  }
}