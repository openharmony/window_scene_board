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

import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CustomPromise } from '@ohos/frameworkwrapper';
import type { PropertyDefaultValue } from './AnimConstants';
import { AnimValue, PROPERTY_MAP, PropertyType } from './AnimConstants';

const TAG = 'ComponentAnimState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 属性限制值name
 */
const PROPERTY_LIMIT = 'PropertyLimit';

/**
 * 默认动效场景
 */
const DEFAULT_ANIM_SCENE = 'default_anim_scene';

/**
 * 切割属性相关集
 */
const CLIP_PROPERTY: PropertyType[] = [
  PropertyType.CLIP_WIDTH,
  PropertyType.CLIP_HEIGHT,
  PropertyType.BORDER_RADIUS_TL,
  PropertyType.BORDER_RADIUS_TR,
  PropertyType.BORDER_RADIUS_BL,
  PropertyType.BORDER_RADIUS_BR,
  PropertyType.CLIP_OFFSET_X,
  PropertyType.CLIP_OFFSET_Y
];

/**
 * 扩展切割路径动效属性
 */
export class ExtendClipPath implements AnimatableArithmetic<ExtendClipPath> {
  /**
   * 标记动效是否有效
   */
  private isAnimValid: boolean = true;

  /**
   * 标记动效是否生效
   *
   * @param isValid true动效生效
   * @returns 链式
   */
  bindAnimValid(isValid: boolean): ExtendClipPath {
    this.isAnimValid = isValid;
    return this;
  }

  /**
   * 切割动效是否生效
   *
   * @returns true生效
   */
  isClipAnimValid(): boolean {
    return this.isAnimValid;
  }

  /**
   * 设置属性值
   *
   * @param property 属性
   * @param value 值
   */
  setPropertyValue(property: PropertyType, value?: number): void {
    let key = this.getPropertyKey(property);
    if (CommonUtils.isInvalid(key)) {
      return;
    }
    this[key] = value;
  }

  /**
   * 获取属性值
   *
   * @param property 属性
   * @returns 值
   */
  getPropertyValue(property: PropertyType): number | undefined {
    let key = this.getPropertyKey(property);
    if (CommonUtils.isInvalid(key)) {
      return undefined;
    }
    return this[key];
  }

  /**
   * 获取裁剪路径
   * 裁剪偏移量 + 宽高 + 圆角
   *
   * @returns 裁剪路径
   */
  getClipPathValue(): string | undefined {
    // 无宽高动效，则无需裁剪
    let width = this.getPropertyValue(PropertyType.CLIP_WIDTH);
    let height = this.getPropertyValue(PropertyType.CLIP_HEIGHT);
    if (CommonUtils.isInvalid(width) || CommonUtils.isInvalid(height)) {
      return undefined;
    }
    width = vp2px(width);
    height = vp2px(height);
    let tlRadius = vp2px(this.getPropertyValue(PropertyType.BORDER_RADIUS_TL) ?? AnimValue.VALUE_MIN);
    let trRadius = vp2px(this.getPropertyValue(PropertyType.BORDER_RADIUS_TR) ?? AnimValue.VALUE_MIN);
    let blRadius = vp2px(this.getPropertyValue(PropertyType.BORDER_RADIUS_BL) ?? AnimValue.VALUE_MIN);
    let brRadius = vp2px(this.getPropertyValue(PropertyType.BORDER_RADIUS_BR) ?? AnimValue.VALUE_MIN);
    let offsetX = vp2px(this.getPropertyValue(PropertyType.CLIP_OFFSET_X) ?? AnimValue.VALUE_MIN);
    let offsetY = vp2px(this.getPropertyValue(PropertyType.CLIP_OFFSET_Y) ?? AnimValue.VALUE_MIN);

    // 矩形带有圆角
    return `M${offsetX} ${offsetY + tlRadius} \
      A${tlRadius} ${tlRadius} 90 0 1 ${offsetX + tlRadius} ${offsetY} \
      L${offsetX + width - trRadius} ${offsetY} \
      A${trRadius} ${trRadius} 90 0 1 ${offsetX + width} ${offsetY + trRadius} \
      L${offsetX + width} ${offsetY + height - brRadius} \
      A${brRadius} ${brRadius} 90 0 1 ${offsetX + width - brRadius} ${offsetY + height} \
      L${offsetX + blRadius} ${offsetY + height} \
      A${blRadius} ${blRadius} 90 0 1 ${offsetX} ${offsetY + height - blRadius} \
      L${offsetX} ${offsetY + tlRadius} Z`;
  }

  /**
   * 复写，加法
   *
   * @param rhs 待处理值
   * @returns 最终值
   */
  plus(rhs: ExtendClipPath): ExtendClipPath {
    let result = new ExtendClipPath();
    CLIP_PROPERTY.forEach((property) => {
      result.plusValue(property, this.getPropertyValue(property), rhs.getPropertyValue(property));
    });
    return result;
  }

  /**
   * 复写，减法
   *
   * @param rhs 待处理值
   * @returns 最终值
   */
  subtract(rhs: ExtendClipPath): ExtendClipPath {
    let result = new ExtendClipPath();
    CLIP_PROPERTY.forEach((property) => {
      result.subValue(property, this.getPropertyValue(property), rhs.getPropertyValue(property));
    });
    return result;
  }

  /**
   * 复写，乘法
   *
   * @param scale 待处理值
   * @returns 最终值
   */
  multiply(scale: number): ExtendClipPath {
    let result = new ExtendClipPath();
    CLIP_PROPERTY.forEach((property) => {
      result.mulValue(property, scale, this.getPropertyValue(property));
    });
    return result;
  }

  /**
   * 相等判断
   *
   * @param rhs 待处理值
   * @returns true相等
   */
  equals(rhs: ExtendClipPath): boolean {
    // 以宽度值为准
    return this.getPropertyValue(PropertyType.CLIP_WIDTH) === rhs.getPropertyValue(PropertyType.CLIP_WIDTH) &&
      this.getPropertyValue(PropertyType.CLIP_HEIGHT) === rhs.getPropertyValue(PropertyType.CLIP_HEIGHT);
  }

  /**
   * 值相加
   *
   * @param property 属性
   * @param pre 值1
   * @param other 值2
   * @returns 链式
   */
  private plusValue(property: PropertyType, pre?: number, other?: number): ExtendClipPath {
    // 无值，则undefined
    if (CommonUtils.isInvalid(pre) || CommonUtils.isInvalid(other)) {
      this.bindAnimValid(false);
      this.setPropertyValue(property);
      return this;
    }
    // 有值，相加
    pre = pre ?? AnimValue.VALUE_MIN;
    other = other ?? AnimValue.VALUE_MIN;
    this.setPropertyValue(property, pre + other);
    return this;
  }

  /**
   * 值相减
   *
   * @param property 属性
   * @param pre 值1
   * @param other 值2
   * @returns 链式
   */
  private subValue(property: PropertyType, pre?: number, other?: number): ExtendClipPath {
    // 无值，则undefined
    if (CommonUtils.isInvalid(pre) || CommonUtils.isInvalid(other)) {
      this.bindAnimValid(false);
      this.setPropertyValue(property);
      return this;
    }
    // 有值，相减
    pre = pre ?? AnimValue.VALUE_MIN;
    other = other ?? AnimValue.VALUE_MIN;
    this.setPropertyValue(property, pre - other);
    return this;
  }

  /**
   * 值相乘
   *
   * @param property 属性
   * @param scale 系数
   * @param value 值
   * @returns 链式
   */
  private mulValue(property: PropertyType, scale: number, value?: number): ExtendClipPath {
    // 无值，则undefined
    if (CommonUtils.isInvalid(value)) {
      this.bindAnimValid(false);
      this.setPropertyValue(property);
      return this;
    }
    // 有值，相乘
    this.setPropertyValue(property, scale * value!);
    return this;
  }

  /**
   * 获取属性名称
   *
   * @param property 属性类型
   * @returns 属性名称
   */
  private getPropertyKey(property: PropertyType): string | undefined {
    return PROPERTY_MAP.get(property)?.propertyName;
  }
}

/**
 * 组件动画状态管理
 */
@Observed
export class ComponentAnimState {
  /**
   * 组件标识名
   */
  private componentName: string;

  /**
   * 当前动效场景集
   */
  private animSceneNames: Set<string> = new Set();

  /**
   * 当前动效场景是否执行完毕
   */
  public animScenePromise: Map<string, CustomPromise<void>> = new Map();

  /**
   * 动效场景移除定时任务
   */
  public animSceneRemoveTask: Map<string, number> = new Map();

  /**
   * 扩展切割路径动效属性，默认不生效
   */
  private clipPath?: ExtendClipPath = new ExtendClipPath().bindAnimValid(false);

  /**
   * 动效参数
   */
  animParam?: AnimateParam;

  /**
   * 组件出现、消失转场动效
   */
  transition?: TransitionEffect;

  /**
   * 标记当前是否动画中
   */
  isAnimating: boolean = false;

  /**
   * 标记当前是否跟手中
   */
  isFollowing: boolean = false;

  /**
   * 是否切割组件，默认不涉及
   */
  isClip?: boolean;

  /**
   * 卡片默认高度
   */
  itemCardDefaultHeight: number = 0;

  /**
   * 构造
   *
   * @param name 标示名
   */
  constructor(name: string) {
    this.componentName = name;
  }

  /**
   * 获取标识名
   *
   * @returns 标识名
   */
  getComponentName(): string {
    return this.componentName;
  }

  getCurrentSceneList(): String {
    return Array.from(this.animSceneNames).join(',');
  }

  /**
   * 设置是否动效中
   *
   * @param isAnimating true动效中
   * @param animScene 动效场景
   * @param isForceRemove 是否开启5秒强制移除
   */
  setAnimating(isAnimating: boolean, animScene?: string, isForceRemove: boolean = true): void {
    let sceneName = CommonUtils.isInvalid(animScene) ? DEFAULT_ANIM_SCENE : animScene!;
    if (isAnimating) {
      this.animSceneNames.add(sceneName);
      this.animScenePromise.set(sceneName, new CustomPromise());
    } else {
      this.animSceneNames.delete(sceneName);
      this.animScenePromise.get(sceneName)?.resolve();
      this.animScenePromise.delete(sceneName);
    }
    // 开启强制移除
    if (isForceRemove) {
      if (isAnimating) {
        this.scheduledRemoveScene(sceneName);
      } else {
        clearTimeout(this.animSceneRemoveTask.get(sceneName));
        this.animSceneRemoveTask.delete(sceneName);
      }
    }
    // 存在动效场景，则标示动效中；不存在动效场景，则置为动效结束
    this.isAnimating = !ArrayUtils.isEmpty(this.animSceneNames);
  }

  private scheduledRemoveScene(sceneName: string): void {
    clearTimeout(this.animSceneRemoveTask.get(sceneName));
    let taskId = setTimeout(() => {
      let status = this.animSceneNames.delete(sceneName);
      if (status) {
        log.showWarn(`anim scene ${sceneName} is not removeed properly`);
      }
      this.animSceneRemoveTask.delete(sceneName);
      this.isAnimating = !ArrayUtils.isEmpty(this.animSceneNames);
    }, 5000);
    this.animSceneRemoveTask.set(sceneName, taskId);
  }

  /**
   * 获取胶囊动效场景Promise
   *
   * @param animScene 动效场景
   * @returns promise
   */
  public getAnimationPromise(animScene: string = DEFAULT_ANIM_SCENE): CustomPromise<void> | undefined {
    return this.animScenePromise.get(animScene);
  }

  public awaitAnimateEnd(): Promise<void[]> {
    return Promise.all([...this.animScenePromise.values()]);
  }

  /**
   * 目标动效场景是否动效中
   *
   * @param animScene 目标场景
   * @returns true动效中
   */
  isSceneAnimating(animScene?: string): boolean {
    let sceneName = CommonUtils.isInvalid(animScene) ? DEFAULT_ANIM_SCENE : animScene!;
    return this.animSceneNames.has(sceneName);
  }

  /**
   * 设置动效参数
   *
   * @param param 动效参数
   * @returns 链式
   */
  setAnimParam(param: AnimateParam): ComponentAnimState {
    this.animParam = param;
    return this;
  }

  /**
   * 设置转场动效
   *
   * @param transition 转场动效
   * @returns 链式
   */
  setTransition(transition: TransitionEffect): ComponentAnimState {
    this.transition = transition;
    return this;
  }

  /**
   * 设置是否切割组件
   *
   * @param clip true切割
   * @returns 链式
   */
  setClip(clip?: boolean): ComponentAnimState {
    this.isClip = clip;
    return this;
  }

  /**
   * 是否切割组件
   *
   * @returns true切割
   */
  isClipComponent(): boolean {
    // 动效期间不切割
    return !this.isAnimating && (this.isClip ?? true);
  }

  /**
   * 添加子组件动效状态
   *
   * @param childName 子组件标识名
   * @param state 子组件动效状态
   * @returns 链式
   */
  addChildAnimState(childName: string, state?: ComponentAnimState): ComponentAnimState {
    if (CommonUtils.isInvalid(childName)) {
      return this;
    }
    let childState = state;
    if (CommonUtils.isInvalid(childState)) {
      childState = new ComponentAnimState(childName);
    }
    this[childName] = childState;
    return this;
  }

  /**
   * 获取子组件动效状态
   *
   * @param childName 子组件标识名
   * @returns 子组件动效状态
   */
  getChildAnimState(childName: string): ComponentAnimState | undefined {
    return this[childName];
  }

  /**
   * 清除子组件动效状态
   *
   * @param childName 子组件标识名
   */
  removeChildAnimState(childName: string): void {
    this[childName] = undefined;
  }

  /**
   * 清空属性
   * 删除对应属性的相关变量
   *
   * @param property 属性类型
   * @returns 链式
   */
  clearProperty(property: PropertyType): ComponentAnimState {
    let key = this.getPropertyKey(property);
    this[key] = undefined;
    return this;
  }

  /**
   * 清空限制属性
   *
   * @param property 属性类型
   * @returns 链式
   */
  clearPropertyLimit(property: PropertyType): ComponentAnimState {
    let limitKey = this.getPropertyLimitKey(property);
    this[limitKey] = undefined;
    return this;
  }

  /**
   * 清除统一圆角
   *
   * @returns 链式
   */
  clearRadius(): ComponentAnimState {
    this.clearProperty(PropertyType.BORDER_RADIUS_TL);
    this.clearProperty(PropertyType.BORDER_RADIUS_TR);
    this.clearProperty(PropertyType.BORDER_RADIUS_BL);
    this.clearProperty(PropertyType.BORDER_RADIUS_BR);
    return this;
  }

  /**
   * 清除切割路径
   *
   * @returns 链式
   */
  clearClipPath(): ComponentAnimState {
    if (this.clipPath?.isClipAnimValid()) {
      let newClipPath = new ExtendClipPath().bindAnimValid(false);
      CLIP_PROPERTY.forEach((property) => {
        newClipPath.setPropertyValue(property, this.getPropertyValue(property));
      });
      this.clipPath = newClipPath;
    }
    return this;
  }

  /**
   * 设置属性限制值
   *
   * @param property 属性类型
   * @param limitValue 限制默认值
   * @return 链式
   */
  setPropertyLimit(property: PropertyType, limitValue: PropertyDefaultValue): ComponentAnimState {
    let key = this.getPropertyLimitKey(property);
    if (CommonUtils.isInvalid(key)) {
      return this;
    }
    this[key] = limitValue;
    return this;
  }

  /**
   * 设置属性值
   *
   * @param property 属性类型
   * @param value 属性值
   * @returns 链式
   */
  setPropertyValue(property: PropertyType, value: number): ComponentAnimState {
    let key = this.getPropertyKey(property);
    if (CommonUtils.isInvalid(key)) {
      return this;
    }
    this[key] = this.getValidValue(property, value);
    return this;
  }

  /**
   * 设置统一圆角
   *
   * @param radius 圆角
   * @returns 链式
   */
  setRadiusValue(radius: number): ComponentAnimState {
    return this.setPropertyValue(PropertyType.BORDER_RADIUS_TL, radius)
      .setPropertyValue(PropertyType.BORDER_RADIUS_TR, radius)
      .setPropertyValue(PropertyType.BORDER_RADIUS_BL, radius)
      .setPropertyValue(PropertyType.BORDER_RADIUS_BR, radius);
  }

  /**
   * 生成新的切割路径
   *
   * @returns 链式
   */
  generateClipPath(): ComponentAnimState {
    let newClipPath = new ExtendClipPath();
    CLIP_PROPERTY.forEach((property) => {
      newClipPath.setPropertyValue(property, this.getPropertyValue(property));
    });
    this.clipPath = newClipPath;
    return this;
  }

  /**
   * 获取切割路径
   *
   * @returns 切割路径
   */
  getClipPath(): ExtendClipPath | undefined {
    return this.clipPath;
  }

  /**
   * 获取属性值
   * 不存在则取初始值
   *
   * @param property 属性类型
   * @returns 属性值
   */
  getPropertyValue(property: PropertyType): number | undefined {
    let key = this.getPropertyKey(property);
    if (CommonUtils.isInvalid(key)) {
      return undefined;
    }
    let current = this[key];
    if (CommonUtils.isInvalid(current)) {
      return this.getPropertyInitValue(property);
    }
    return current as number;
  }

  /**
   * 获取属性百分比值
   *
   * @param property 属性类型
   * @returns 属性值
   */
  getPropertyPercentValue(property: PropertyType): string | undefined {
    let value = this.getPropertyValue(property);
    if (CommonUtils.isInvalid(value)) {
      return undefined;
    }
    return `${value}%`;
  }

  /**
   * 获取有效值
   *
   * @param property 属性类型
   * @param value 原始值
   */
  private getValidValue(property: PropertyType, value: number): number {
    if (!CommonUtils.isNumber(value)) {
      return value;
    }

    // 限制最大、最小值
    let propertyLimit = this.getPropertyLimit(property);
    let minValue = propertyLimit?.minValue;
    let maxValue = propertyLimit?.maxValue;
    if (CommonUtils.isNumber(minValue) && value < minValue) {
      return minValue;
    }
    if (CommonUtils.isNumber(maxValue) && value > maxValue) {
      return maxValue;
    }
    return value;
  }

  /**
   * 获取属性名称
   *
   * @param property 属性类型
   * @returns 属性名称
   */
  private getPropertyKey(property: PropertyType): string | undefined {
    return PROPERTY_MAP.get(property)?.propertyName;
  }

  /**
   * 获取属性初始化值
   *
   * @param property 属性类型
   * @returns 默认初始值
   */
  private getPropertyInitValue(property: PropertyType): number | undefined {
    return this.getPropertyLimit(property)?.initValue;
  }

  /**
   * 获取属性限制map值
   *
   * @param property 属性类型
   * @returns 属性限制map
   */
  private getPropertyLimit(property: PropertyType): PropertyDefaultValue | undefined {
    let limit = this[this.getPropertyLimitKey(property)];
    if (CommonUtils.isInvalid(limit)) {
      return PROPERTY_MAP.get(property);
    }
    return limit as PropertyDefaultValue;
  }

  /**
   * 获取属性限制map键值
   *
   * @param property 属性类型
   * @returns 键值
   */
  private getPropertyLimitKey(property: PropertyType): string | undefined {
    let key = this.getPropertyKey(property);
    if (CommonUtils.isInvalid(key)) {
      return undefined;
    }
    return `${key}${PROPERTY_LIMIT}`;
  }
}