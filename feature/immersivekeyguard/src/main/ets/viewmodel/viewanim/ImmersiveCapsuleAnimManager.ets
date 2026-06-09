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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AnimValue, ImmersiveConstants } from '@ohos/systemuicommon';
import { ImmersiveAnimKey, ImmersiveAnimScene } from '../../common/anim/ImmersiveAnimConstants';
import { CapsulePositionType } from '../../common/ImmersiveConstants';
import { ImmersiveAnimInfo } from '../../model/data/anim/ImmersiveAnimInfo';
import { AnimStyleType, ImmersiveAnimStyle } from '../../model/data/anim/ImmersiveAnimStyle';
import { ImmersiveCapsuleConstants as CapConst } from '../../common/constants/ImmersiveCapsuleConstants';
import { ImmersiveBaseAnim } from '../../common/anim/ImmersiveBaseAnim';
import { ImmersiveAnimNode, ImmersiveAnimUnit } from '../../common/anim/ImmersiveAnimUnit';
import { ImmersiveSerialAnim } from '../../common/anim/ImmersiveSerialAnim';
import { WBaseProperty, WAnimProperty} from '@ohos/screenlockcommon';
import { BaseState, IBaseStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ComponentPosition, CmpPosWrapper, WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { ImmersiveCapsuleList } from '../viewdata/ImmersiveCapsuleList';
import { CapTypeChain } from '../../common/anim/CapTypeChain';

const TAG = 'ImmersiveCapsuleAnimManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 胶囊动效状态集
 */
const CAPSULE_ANIM_INFO: CapsulePositionType[] = [
  CapsulePositionType.TYPE_CONTENT,
  CapsulePositionType.TYPE_SHADOW,
  CapsulePositionType.TYPE_REMIND,
  CapsulePositionType.TYPE_ANIM_CONTENT,
  CapsulePositionType.TYPE_ANIM_SHADOW,
];

// 胶囊交互相关动效
export const CAPSULE_ANIM_SCENE: Set<ImmersiveAnimScene> = new Set([
  ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH_BACK,
  ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX,
  ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX,
  ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH,
  ImmersiveAnimScene.SCENE_CAPSULE_TO_CARD,
  ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE,
  ImmersiveAnimScene.SCENE_CARD_TO_LIST,
  ImmersiveAnimScene.SCENE_LIST_TO_CARD,
]);

/**
 * 胶囊动效UI样式创建
 */
const CREATE_CAPSULE_ANIM_STYLE = (type: CapsulePositionType): ImmersiveAnimStyle => {
  switch (type) {
    case CapsulePositionType.TYPE_CONTENT:
    case CapsulePositionType.TYPE_ANIM_CONTENT:
    case CapsulePositionType.TYPE_REMIND:
      return new ImmersiveAnimStyle()
        .bindStyle(AnimStyleType.RADIUS, CapConst.CAPSULE_RADIUS)
        .bindStyle(AnimStyleType.PADDING_TOP, 6)
        .bindStyle(AnimStyleType.PADDING_LEFT, 8)
        .bindStyle(AnimStyleType.ALPHA, AnimValue.VALUE_MAX);

    case CapsulePositionType.TYPE_SHADOW:
    case CapsulePositionType.TYPE_ANIM_SHADOW:
      return new ImmersiveAnimStyle()
        .bindStyle(AnimStyleType.RADIUS, CapConst.CAPSULE_RADIUS)
        .bindStyle(AnimStyleType.PADDING_TOP, 6)
        .bindStyle(AnimStyleType.PADDING_LEFT, 8)
        .bindStyle(AnimStyleType.ALPHA, AnimValue.VALUE_MAX)
        .bindStyle(AnimStyleType.MARGIN_TOP, CapConst.STACKED_DISTANCE)
        .bindStyle(AnimStyleType.MARGIN_LEFT, CapConst.STACKED_DISTANCE)
        .bindStyle(AnimStyleType.MARGIN_RIGHT, CapConst.STACKED_DISTANCE);
    default:
      break;
  }
  return new ImmersiveAnimStyle();
};

/**
 * 胶囊动效UI样式
 */
const CAPSULE_ANIM_STYLE: Map<CapsulePositionType, ImmersiveAnimStyle> = new Map([
  // 内容胶囊默认样式
  [CapsulePositionType.TYPE_CONTENT, CREATE_CAPSULE_ANIM_STYLE(CapsulePositionType.TYPE_CONTENT)],
  // 阴影胶囊默认样式
  [CapsulePositionType.TYPE_SHADOW, CREATE_CAPSULE_ANIM_STYLE(CapsulePositionType.TYPE_SHADOW)],
  // 动效内容胶囊默认样式
  [CapsulePositionType.TYPE_ANIM_CONTENT, CREATE_CAPSULE_ANIM_STYLE(CapsulePositionType.TYPE_ANIM_CONTENT)],
  // 动效阴影胶囊默认样式
  [CapsulePositionType.TYPE_ANIM_SHADOW, CREATE_CAPSULE_ANIM_STYLE(CapsulePositionType.TYPE_ANIM_SHADOW)],
  // 强提醒胶囊默认样式
  [CapsulePositionType.TYPE_REMIND, CREATE_CAPSULE_ANIM_STYLE(CapsulePositionType.TYPE_REMIND)]
]);

/**
 * 胶囊点击时停止的动效场景集合
 */
const CAPSULE_CLICK_STOP_ANIM: ImmersiveAnimScene[] = [
  ImmersiveAnimScene.SCENE_CAPSULE_STACK_SHOW,
  ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW,
  ImmersiveAnimScene.SCENE_CAPSULE_ROOT_HIDE,
  ImmersiveAnimScene.SCENE_CAPSULE_STACK_REMOVE,
  ImmersiveAnimScene.SCENE_CAPSULE_REMIND,
  ImmersiveAnimScene.SCENE_CAPSULE_REMIND_EXIT
];

/**
 * 胶囊动效打断场景
 */
const CAPSULE_ANIM_INTERRUPT: Map<ImmersiveAnimScene, ImmersiveAnimScene[]> = new Map([
  [ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW, [ImmersiveAnimScene.SCENE_CAPSULE_ROOT_HIDE]]
]);

type CapsuleDataFlush = (isAnim?: boolean) => void;

/**
 * 沉浸锁屏胶囊动效管理
 */
export class ImmersiveCapsuleAnimManager {
  /**
   * 胶囊根布局动效状态映射
   */
  private rootAnimState: ImmersiveAnimInfo = new ImmersiveAnimInfo(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT,
    new ImmersiveAnimStyle());

  /**
   * 胶囊默认链条，内容胶囊 > 阴影胶囊
   */
  private defaultCapChain: CapTypeChain = new CapTypeChain(CapsulePositionType.TYPE_CONTENT)
    .addChain(new CapTypeChain(CapsulePositionType.TYPE_SHADOW));

  /**
   * 胶囊类型映射数据唯一标识
   */
  private hashcodeMap: Map<CapsulePositionType, string> = new Map();

  /**
   * 动效实例缓存
   */
  private sceneAnimations: Map<ImmersiveAnimScene, ImmersiveBaseAnim> = new Map();

  /**
   * 胶囊可显示数据列表
   */
  private showList: ImmersiveCapsuleList = new ImmersiveCapsuleList();

  /**
   * 胶囊数据更新回调
   */
  private checkAndUpdateUiDataFunc: CapsuleDataFlush = (isAnim?: boolean) => {
  };
  /**
   * 动效期间是否存在数据更新
   */
  private isDataUpdate: boolean = false;

  private rootAnimStateListener: IBaseStateChangeListener = {
    onStateChange: (stateType, stateId, property) => {
      if (property === WAnimProperty.ANIMATING && !this.getRootAnimState().isSceneAnimating() && this.isDataUpdate) {
        setTimeout(() => {
          log.showWarn('flushCapsuleData');
          this.isDataUpdate = false;
          this.checkAndUpdateUiDataFunc?.(true);
        });
      }
    }
  }

  public setImmersiveCapsuleList(showList: ImmersiveCapsuleList): void {
    this.showList = showList;
  }

  public isContentCapsuleShow(): boolean {
    return !CommonUtils.isInvalid(this.showList?.getNtfData(CapsulePositionType.TYPE_CONTENT));
  }

  public setUpdateCapsuleUiData(callback: CapsuleDataFlush): void {
    this.checkAndUpdateUiDataFunc = callback;
  }

  public setDataUpdateStatus(isUpdate: boolean): void {
    this.isDataUpdate = isUpdate;
  }

  /**
   * 构造
   */
  constructor() {
    this.getRootAnimState().registerStateChangeListener?.(this.rootAnimStateListener);
    // 初始构建子组件动效状态
    CAPSULE_ANIM_INFO.forEach((type) => {
      let childInfo: ImmersiveAnimInfo = new ImmersiveAnimInfo(type, CAPSULE_ANIM_STYLE.get(type));
      // 子组件多加一层动效状态
      childInfo.getWidgetAnimState()?.addChildState(BaseState.wrap(WidgetAnimState, type));
      this.rootAnimState.addChildAnimInfo(childInfo);
    });
    this.initSceneAnim();
  }

  /**
   * 胶囊默认链条
   *
   * @returns 胶囊类型链条
   */
  getDefaultCapChain(): CapTypeChain {
    return this.defaultCapChain;
  }

  /**
   * 刷新胶囊类型标识
   *
   * @param type 胶囊类型
   * @param hashcode 标示
   */
  refreshHashcode(type: CapsulePositionType, hashcode?: string): void {
    let isClear = CommonUtils.isInvalid(hashcode);
    if (isClear) {
      this.hashcodeMap.delete(type);
    } else {
      this.hashcodeMap.set(type, hashcode!);
    }
  }

  /**
   * 获取映射胶囊类型
   *
   * @param hashcode 标示
   * @returns 胶囊类型
   */
  getMapCapsuleType(hashcode?: string): CapsulePositionType {
    let resultType = CAPSULE_ANIM_INFO.find((type) => {
      return this.hashcodeMap.get(type) === hashcode;
    });
    if (CommonUtils.isInvalid(resultType)) {
      resultType = CapsulePositionType.TYPE_NONE;
    }
    return resultType as CapsulePositionType;
  }

  /**
   * 获取子组件数据唯一标示
   *
   * @param type 胶囊类型
   * @returns 数据标识
   */
  getChildHashcode(type: CapsulePositionType): string | undefined {
    return this.hashcodeMap.get(type);
  }

  /**
   * 内容胶囊判断
   *
   * @param type 胶囊类型
   * @returns true内容胶囊
   */
  isCapsuleContent(type: CapsulePositionType): boolean {
    return type === CapsulePositionType.TYPE_CONTENT;
  }

  /**
   * 阴影胶囊判断
   *
   * @param type 胶囊类型
   * @returns true阴影胶囊
   */
  isCapsuleShadow(type: CapsulePositionType): boolean {
    return type === CapsulePositionType.TYPE_SHADOW;
  }

  /**
   * 无匹配胶囊判断
   *
   * @param type 胶囊类型
   * @returns true无匹配胶囊
   */
  isCapsuleNone(type: CapsulePositionType): boolean {
    return type === CapsulePositionType.TYPE_NONE;
  }

  /**
   * 获取根组件动效UI样式
   *
   * @returns UI样式
   */
  getRootAnimStyle(): ImmersiveAnimStyle {
    return this.rootAnimState.getComponentAnimStyle();
  }

  /**
   * 设置根组件动效UI样式对应值
   *
   * @param type 样式类型
   * @param value 值
   */
  setRootStyleValue(type: AnimStyleType, value?: number): void {
    this.getRootAnimStyle()?.bindStyle(type, value);
  }

  /**
   * 获取根组件动效状态
   *
   * @returns 动效状态
   */
  getRootAnimState(): WidgetAnimState {
    return this.rootAnimState.getWidgetAnimState();
  }

  /**
   * 获取子组件动效UI样式
   *
   * @param type 胶囊类型
   * @returns UI样式
   */
  getChildAnimStyle(type: CapsulePositionType): ImmersiveAnimStyle | undefined {
    return this.getChildAnimInfo(type)?.getComponentAnimStyle();
  }

  /**
   * 获取胶囊有效样式
   *
   * @param type 胶囊类型
   * @returns 样式
   */
  getCapValidStyle(type: CapsulePositionType): ImmersiveAnimStyle {
    // 优先目标类型
    let style = this.getChildAnimStyle(type);
    if (!CommonUtils.isInvalid(style)) {
      return style as ImmersiveAnimStyle;
    }
    // 其次阴影胶囊
    style = this.getChildAnimStyle(CapsulePositionType.TYPE_SHADOW);
    if (!CommonUtils.isInvalid(style)) {
      return style as ImmersiveAnimStyle;
    }
    // 最后内容胶囊
    return this.getChildAnimStyle(CapsulePositionType.TYPE_CONTENT) as ImmersiveAnimStyle;
  }

  /**
   * 设置子组件动效UI样式对应值
   *
   * @param posType 胶囊类型
   * @param styleType 样式类型
   * @param value 值
   */
  setChildStyleValue(posType: CapsulePositionType, styleType: AnimStyleType, value?: number): void {
    this.getChildAnimStyle(posType)?.bindStyle(styleType, value);
  }

  /**
   * 获取子组件的动效状态
   *
   * @param type 胶囊类型
   * @returns 动效状态
   */
  getChildAnimState(type: CapsulePositionType): WidgetAnimState | undefined {
    return this.getChildAnimInfo(type)?.getWidgetAnimState();
  }

  /**
   * 胶囊有效动效状态
   *
   * @param capType 胶囊类型
   * @returns 动效状态
   */
  getCapValidAnimSt(capType: CapsulePositionType): WidgetAnimState {
    // 优先目标类型
    let state = this.getChildAnimState(capType);
    if (!CommonUtils.isInvalid(state)) {
      return state as WidgetAnimState;
    }
    // 其次阴影胶囊
    state = this.getChildAnimState(CapsulePositionType.TYPE_SHADOW);
    if (!CommonUtils.isInvalid(state)) {
      return state as WidgetAnimState;
    }
    // 最后内容胶囊
    return this.getChildAnimState(CapsulePositionType.TYPE_CONTENT) as WidgetAnimState;
  }

  /**
   * 设置根组件显示位置
   *
   * @param area 显示位置
   */
  setRootViewArea(area?: Area | SizeOptions): void {
    this.rootAnimState.setComponentArea(area);
  }

  /**
   * 获取根组件显示位置
   *
   * @returns 组件位置
   */
  getRootViewPosition(): ComponentPosition {
    return this.rootAnimState.getComponentPosition();
  }

  /**
   * 设置子组件显示位置
   *
   * @param type 胶囊类型
   * @param area 显示位置
   */
  setChildViewArea(type: CapsulePositionType, area?: Area | SizeOptions): void {
    return this.getChildAnimInfo(type)?.setComponentArea(area);
  }

  updateChildViewPosition(type: CapsulePositionType, width: number): void {
    let childInfo = this.rootAnimState.getChildAnimInfo(type);
    childInfo.updateAreaWidth(width);
  }

  /**
   * 获取子组件显示位置
   *
   * @param type 胶囊类型
   * @returns 显示位置
   */
  getChildViewPosition(type: CapsulePositionType): ComponentPosition | undefined {
    return this.getChildAnimInfo(type)?.getComponentPosition();
  }

  /**
   * 获取胶囊有效位置
   *
   * @param capType 胶囊类型
   * @returns 位置
   */
  getCapValidPos(capType: CapsulePositionType): ComponentPosition {
    // 优先目标类型
    let pos = this.getChildViewPosition(capType);
    if (CmpPosWrapper.wrapper(pos).isPosValid()) {
      return pos as ComponentPosition;
    }
    // 其次阴影胶囊
    pos = this.getChildViewPosition(CapsulePositionType.TYPE_SHADOW);
    if (CmpPosWrapper.wrapper(pos).isPosValid()) {
      return pos as ComponentPosition;
    }
    // 最后内容胶囊
    return this.getChildViewPosition(CapsulePositionType.TYPE_CONTENT) as ComponentPosition;
  }

  /**
   * 设置胶囊根组件动效中状态
   *
   * @param isAnimating 是否动效中
   * @param animScene 动效场景
   */
  setRootAnimating(isAnimating: boolean, animScene?: ImmersiveAnimScene): void {
    // 标示胶囊是否动效中
    this.getRootAnimState().setAnimScene({ isAnimating: isAnimating, animScene: animScene });
  }

  /**
   * 设置胶囊子组件动效中状态
   *
   * @param isAnimating 是否动效中
   * @param animScene 动效场景
   * @param child 参与动效的子组件集
   */
  setChildAnimating(isAnimating: boolean, animScene?: ImmersiveAnimScene, ...child: CapsulePositionType[]): void {
    // 标示胶囊是否动效中
    child?.forEach((type) => {
      this.getChildAnimState(type)?.setAnimScene({ isAnimating: isAnimating, animScene: animScene });
    });
  }

  /**
   * 启动动效
   *
   * @param scene 场景
   * @param onStart 起始回调
   * @param onEnd 结束回调
   */
  startAnim(scene: ImmersiveAnimScene, onStart?: () => void, onEnd?: () => void): void {
    let animStart = () => {
      onStart?.();
    }
    let animEnd = () => {
      onEnd?.();
    }
    let anim = this.sceneAnimations.get(scene);
    if (CommonUtils.isInvalid(anim)) {
      log.showInfo(`startAnim ${scene} is invalid`);
      return;
    }
    if (scene === ImmersiveAnimScene.SCENE_CAPSULE_TOP_UPDATE) {
      this.initTopUpdateAnimParam();
    }
    CAPSULE_ANIM_INTERRUPT.get(scene)?.forEach(checkScene => {
      let checkAnim = this.sceneAnimations.get(checkScene);
      if (checkAnim?.isRunning()) {
        checkAnim.exit();
      }
    });
    anim?.start(animStart, animEnd);
  }

  /**
   * 胶囊到列表场景, 动效打断处理
   */
  interruptCapsuleAnim(): void {
    CAPSULE_CLICK_STOP_ANIM.forEach(scene => {
      let anim = this.sceneAnimations.get(scene);
      if (anim?.isRunning()) {
        anim?.exit();
      }
    });
  }

  /**
   * 设置顶部更新动效参数
   */
  private initTopUpdateAnimParam() {
    let anim = this.sceneAnimations.get(ImmersiveAnimScene.SCENE_CAPSULE_TOP_UPDATE) as ImmersiveSerialAnim;
    if (CommonUtils.isInvalid(anim)) {
      return;
    }
    let foldAnim = anim.getBaseAnim(0);
    let expandAnim = anim.getBaseAnim(1);
    let position = this.getChildViewPosition(CapsulePositionType.TYPE_CONTENT);
    let width = position?.width ?? 0;
    let minWidth = CapConst.getIconAreaSpecs();
    let contentState = this.getChildAnimState(CapsulePositionType.TYPE_CONTENT) as WidgetAnimState;
    let contentChildState = contentState.getChildState(CapsulePositionType.TYPE_CONTENT) as WidgetAnimState;
    foldAnim?.setStateValue(1, contentState, { type: WBaseProperty.CLIP_W, start: width, end: minWidth });
    foldAnim?.setStateValue(1, contentChildState, { type: WBaseProperty.WIDTH, start: width, end: width });
    expandAnim?.setStateValue(1, contentState, { type: WBaseProperty.CLIP_W, start: minWidth, end: width });
    expandAnim?.setStateValue(1, contentChildState, { type: WBaseProperty.WIDTH, start: width, end: width });

    let shadowStyle = this.getChildAnimStyle(CapsulePositionType.TYPE_SHADOW);
    let margin = (shadowStyle?.getStyleValue(AnimStyleType.MARGIN_LEFT) ?? 0) +
      (shadowStyle?.getStyleValue(AnimStyleType.MARGIN_RIGHT) ?? 0);
    position = this.getChildViewPosition(CapsulePositionType.TYPE_SHADOW);
    width = position?.width ?? 0;
    minWidth = Math.max(CapConst.getIconAreaSpecs() - margin, 0);
    let shadowState = this.getChildAnimState(CapsulePositionType.TYPE_SHADOW) as WidgetAnimState;
    let shadowChildState = shadowState.getChildState(CapsulePositionType.TYPE_SHADOW) as WidgetAnimState;
    foldAnim?.setStateValue(1, shadowState, { type: WBaseProperty.CLIP_W, start: width, end: minWidth });
    foldAnim?.setStateValue(1, shadowChildState, { type: WBaseProperty.WIDTH, start: width, end: width });
    expandAnim?.setStateValue(1, shadowState, { type: WBaseProperty.CLIP_W, start: minWidth, end: width });
    expandAnim?.setStateValue(1, shadowChildState, { type: WBaseProperty.WIDTH, start: width, end: width });
  }

  /**
   * 获取子组件动效
   *
   * @param type 胶囊类型
   * @returns 动效
   */
  private getChildAnimInfo(type: CapsulePositionType): ImmersiveAnimInfo | undefined {
    return this.rootAnimState.getChildAnimInfo(type);
  }

  /**
   * 初始化场景动效
   */
  private initSceneAnim() {
    this.initRootShowAnim();
    this.initRootHideAnim();
    this.initStackShowAnim();
    this.initStackRemoveAnim();
    this.initShadowRemoveAnim();
    this.initTopUpdateAnim();
    this.initRemindAnims();
  }

  /**
   * 初始化根布局显示动效
   */
  private initRootShowAnim() {
    let scene = ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW;
    let rootState = this.getRootAnimState();
    // 透明度
    let firstUnit = new ImmersiveAnimUnit()
      .addAnimNode(new ImmersiveAnimNode(rootState).addPropValue({ type: WBaseProperty.ALPHA, start: 0, end: 1.0 }))
      .animDuration(150)
      .animCurve(Curve.Linear);
    // 缩放、模糊半径
    let secondUnit = new ImmersiveAnimUnit()
      .addAnimNode(new ImmersiveAnimNode(rootState)
        .addPropValue({ type: WBaseProperty.SCALE_X, start: 0.6, end: 1.0 })
        .addPropValue({ type: WBaseProperty.SCALE_Y, start: 0.6, end: 1.0 })
        .addPropValue({ type: WBaseProperty.BLUR, start: 50, end: 0 }))
      .animCurve(CapConst.CAPSULE_ANIM_SPRING_CURVE);
    this.sceneAnimations.set(scene, new ImmersiveBaseAnim(scene).addAnimUnit(firstUnit).addAnimUnit(secondUnit));
  }

  /**
   * 初始化根布局消失动效
   */
  private initRootHideAnim() {
    let scene = ImmersiveAnimScene.SCENE_CAPSULE_ROOT_HIDE;
    let rootState = this.getRootAnimState();
    // 透明度
    let firstUnit = new ImmersiveAnimUnit()
      .addAnimNode(new ImmersiveAnimNode(rootState).addPropValue({ type: WBaseProperty.ALPHA, start: 1.0, end: 0 }))
      .animDuration(150)
      .animCurve(Curve.Linear);
    // 缩放、模糊半径
    let secondUnit = new ImmersiveAnimUnit()
      .addAnimNode(new ImmersiveAnimNode(rootState)
        .addPropValue({ type: WBaseProperty.SCALE_X, start: 1.0, end: 0.8 })
        .addPropValue({ type: WBaseProperty.SCALE_Y, start: 1.0, end: 0.8 })
        .addPropValue({ type: WBaseProperty.BLUR, start: 0, end: 50 }))
      .animCurve(CapConst.CAPSULE_ANIM_SPRING_CURVE);
    this.sceneAnimations.set(scene, new ImmersiveBaseAnim(scene).addAnimUnit(firstUnit).addAnimUnit(secondUnit));
  }

  /**
   * 初始化胶囊堆叠显示动效
   */
  private initStackShowAnim() {
    let scene = ImmersiveAnimScene.SCENE_CAPSULE_STACK_SHOW;
    let contentState = this.getChildAnimState(CapsulePositionType.TYPE_CONTENT) as WidgetAnimState;
    let shadowState = this.getChildAnimState(CapsulePositionType.TYPE_SHADOW) as WidgetAnimState;
    let firstUnit = new ImmersiveAnimUnit()
      .addAnimNode(new ImmersiveAnimNode(contentState).addPropValue({ type: WBaseProperty.ALPHA, start: 0, end: 1.0 }))
      .animDuration(150)
      .animCurve(Curve.Linear);
    let secondUnit = new ImmersiveAnimUnit()
      .addAnimNode(new ImmersiveAnimNode(contentState)
        .addPropValue({ type: WBaseProperty.SCALE_X, start: 1.2, end: 1.0 })
        .addPropValue({ type: WBaseProperty.SCALE_Y, start: 1.2, end: 1.0 })
        .addPropValue({ type: WBaseProperty.BLUR, start: 50, end: 0 }))
      .addAnimNode(new ImmersiveAnimNode(shadowState)
        .addPropValue({ type: WBaseProperty.SCALE_X, start: 100 / 94, end: 1.0 })
        .addPropValue({ type: WBaseProperty.SCALE_Y, start: 100 / 94, end: 1.0 })
        .addPropValue({ type: WBaseProperty.TRAN_Y, start: -CapConst.STACKED_DISTANCE, end: 0 }))
      .animCurve(CapConst.CAPSULE_ANIM_SPRING_CURVE);
    this.sceneAnimations.set(scene, new ImmersiveBaseAnim(scene).addAnimUnit(firstUnit).addAnimUnit(secondUnit)
      .addAnimState(this.getRootAnimState()));
  }

  /**
   * 初始化胶囊堆叠删除动效
   */
  private initStackRemoveAnim() {
    let scene = ImmersiveAnimScene.SCENE_CAPSULE_STACK_REMOVE;
    let contentState = this.getChildAnimState(CapsulePositionType.TYPE_CONTENT) as WidgetAnimState;
    let animContentState = this.getChildAnimState(CapsulePositionType.TYPE_ANIM_CONTENT) as WidgetAnimState;
    let firstUnit = new ImmersiveAnimUnit()
      .addAnimNode(new ImmersiveAnimNode(contentState)
        .addPropValue({ type: WBaseProperty.ALPHA, start: 0.51, end: 1.0 }))
      .addAnimNode(new ImmersiveAnimNode(animContentState)
        .addPropValue({ type: WBaseProperty.ALPHA, start: 1.0, end: 0 }))
      .animDuration(150)
      .animCurve(Curve.Linear);
    let secondUnit = new ImmersiveAnimUnit()
      .addAnimNode(new ImmersiveAnimNode(contentState)
        .addPropValue({ type: WBaseProperty.SCALE_X, start: 0.94, end: 1.0 })
        .addPropValue({ type: WBaseProperty.SCALE_Y, start: 0.94, end: 1.0 })
        .addPropValue({ type: WBaseProperty.TRAN_Y, start: CapConst.STACKED_DISTANCE, end: 0 }))
      .addAnimNode(new ImmersiveAnimNode(animContentState)
        .addPropValue({ type: WBaseProperty.SCALE_X, start: 1.0, end: 1.1 })
        .addPropValue({ type: WBaseProperty.SCALE_Y, start: 1.0, end: 1.1 })
        .addPropValue({ type: WBaseProperty.BLUR, start: 0, end: 5 }))
      .animCurve(CapConst.CAPSULE_ANIM_SPRING_CURVE);
    this.sceneAnimations.set(scene, new ImmersiveBaseAnim(scene).addAnimUnit(firstUnit).addAnimUnit(secondUnit)
      .addAnimState(this.getRootAnimState()));
  }

  /**
   * 初始化阴影删除动效
   */
  private initShadowRemoveAnim() {
    let scene = ImmersiveAnimScene.SCENE_CAPSULE_SHADOW_REMOVE;
    let animShadowState = this.getChildAnimState(CapsulePositionType.TYPE_ANIM_SHADOW) as WidgetAnimState;
    let unit = new ImmersiveAnimUnit()
      .addAnimNode(new ImmersiveAnimNode(animShadowState)
        .addPropValue({ type: WBaseProperty.ALPHA, start: 1.0, end: 0 }))
      .animDuration(150)
      .animCurve(Curve.Linear);
    this.sceneAnimations.set(scene, new ImmersiveBaseAnim(scene).addAnimUnit(unit)
      .addAnimState(this.getRootAnimState()));
  }

  /**
   * 初始化顶部更新动效
   */
  private initTopUpdateAnim() {
    let scene = ImmersiveAnimScene.SCENE_CAPSULE_TOP_UPDATE;
    let rootState = this.getRootAnimState();
    let contentState = this.getChildAnimState(CapsulePositionType.TYPE_CONTENT) as WidgetAnimState;
    let contentInnerState = contentState.getChildState(CapsulePositionType.TYPE_CONTENT) as WidgetAnimState;
    let shadowState = this.getChildAnimState(CapsulePositionType.TYPE_SHADOW) as WidgetAnimState;
    let shadowInnerState = shadowState.getChildState(CapsulePositionType.TYPE_SHADOW) as WidgetAnimState;
    let firstUnit = new ImmersiveAnimUnit()
      .addAnimNode(new ImmersiveAnimNode(contentInnerState)
        .addPropValue({type: WBaseProperty.ALPHA, start: 1.0, end: 0}))
      .animDuration(100).animCurve(Curve.Linear);
    let secondUnit = new ImmersiveAnimUnit()
      .addAnimNode(new ImmersiveAnimNode(contentState)
        .addPropValue({ type: WBaseProperty.SCALE_X, start: 1.0, end: 0.95 })
        .addPropValue({ type: WBaseProperty.SCALE_Y, start: 1.0, end: 0.95 })
        .addPropValue({ type: WBaseProperty.CLIP_W, start: -1, end: -1 })
        .enableClip(true))
      .addAnimNode(new ImmersiveAnimNode(shadowState)
        .addPropValue({ type: WBaseProperty.TRAN_Y, start: 0, end: -CapConst.STACKED_DISTANCE })
        .addPropValue({ type: WBaseProperty.CLIP_W, start: -1, end: -1 })
        .enableClip(true))
      .addAnimNode(new ImmersiveAnimNode(contentInnerState)
        .addPropValue({type: WBaseProperty.WIDTH, start: -1, end: -1}))
      .addAnimNode(new ImmersiveAnimNode(shadowInnerState)
        .addPropValue({type: WBaseProperty.WIDTH, start: -1, end: -1}))
      .animDuration(300).animCurve(CapConst.CAPSULE_UPDATE_ANIM_FOLD_CURVE);
    let fold = new ImmersiveBaseAnim(scene).addAnimUnit(firstUnit).addAnimUnit(secondUnit).addAnimState(rootState);

    firstUnit = new ImmersiveAnimUnit()
      .addAnimNode(new ImmersiveAnimNode(contentInnerState).addPropValue({
        type: WBaseProperty.ALPHA,
        start: 0,
        end: 1.0
      }))
      .animDuration(200).animCurve(Curve.Linear);
    secondUnit = new ImmersiveAnimUnit()
      .addAnimNode(new ImmersiveAnimNode(contentState)
        .addPropValue({ type: WBaseProperty.SCALE_X, start: 0.95, end: 1.0 })
        .addPropValue({ type: WBaseProperty.SCALE_Y, start: 0.95, end: 1.0 })
        .addPropValue({ type: WBaseProperty.CLIP_W, start: -1, end: -1 })
        .enableClip(true))
      .addAnimNode(new ImmersiveAnimNode(shadowState)
        .addPropValue({ type: WBaseProperty.TRAN_Y, start: -CapConst.STACKED_DISTANCE, end: 0 })
        .addPropValue({ type: WBaseProperty.CLIP_W, start: -1, end: -1 })
        .enableClip(true))
      .addAnimNode(new ImmersiveAnimNode(contentInnerState)
        .addPropValue({type: WBaseProperty.WIDTH, start: -1, end: -1}))
      .addAnimNode(new ImmersiveAnimNode(shadowInnerState)
        .addPropValue({type: WBaseProperty.WIDTH, start: -1, end: -1}))
      .animCurve(CapConst.CAPSULE_UPDATE_ANIM_EXPAND_CURVE);
    let expand = new ImmersiveBaseAnim(scene).addAnimUnit(firstUnit).addAnimUnit(secondUnit).addAnimState(rootState);
    this.sceneAnimations.set(scene, new ImmersiveSerialAnim(scene).addBaseAnim(fold).addBaseAnim(expand));
  }

  /**
   * 初始化强提醒动效、强提醒退出动效
   */
  private initRemindAnims() {
    this.initRemindAnim(ImmersiveAnimScene.SCENE_CAPSULE_REMIND, CapsulePositionType.TYPE_REMIND,
      CapsulePositionType.TYPE_CONTENT);
    this.initRemindAnim(ImmersiveAnimScene.SCENE_CAPSULE_REMIND_EXIT, CapsulePositionType.TYPE_CONTENT,
      CapsulePositionType.TYPE_REMIND);
  }

  /**
   * 初始化强提醒动效
   *
   * @param scene 场景
   * @param remindType 提醒的胶囊位置类型
   * @param hideType 隐藏的胶囊位置类型
   */
  private initRemindAnim(scene: ImmersiveAnimScene, remindType: CapsulePositionType, hideType: CapsulePositionType) {
    let rootState = this.getRootAnimState();
    let shadowState = this.getChildAnimState(CapsulePositionType.TYPE_SHADOW) as WidgetAnimState;
    let hideState = this.getChildAnimState(hideType) as WidgetAnimState;
    let remindState = this.getChildAnimState(remindType) as WidgetAnimState;
    let remindInnerState = remindState.getChildState(remindType) as WidgetAnimState;

    let firstUnit = new ImmersiveAnimUnit()
      .addAnimNode(new ImmersiveAnimNode(remindInnerState)
        .addPropValue({ type: WBaseProperty.ALPHA, start: 0, end: 1.0 }))
      .addAnimNode(new ImmersiveAnimNode(remindState)
        .addPropValue({ type: WBaseProperty.ALPHA, start: 0.51, end: 1.0 }))
      .addAnimNode(new ImmersiveAnimNode(shadowState)
        .addPropValue({ type: WBaseProperty.ALPHA, start: 0, end: 0 }))
      .animDuration(100)
      .animCurve(Curve.Linear);
    let secondUnit = new ImmersiveAnimUnit()
      .addAnimNode(new ImmersiveAnimNode(remindState)
        .addPropValue({ type: WBaseProperty.SCALE_X, start: 0.94, end: 1.05 })
        .addPropValue({ type: WBaseProperty.SCALE_Y, start: 0.94, end: 1.05 })
        .addPropValue({
          type: WBaseProperty.TRAN_Y, start: CapConst.STACKED_DISTANCE,
          end: CapConst.CAPSULE_HEIGHT + CapConst.CAPSULE_REMIND_ANIM_END_SPACE - CapConst.STACKED_DISTANCE
        })
        .addPropValue({ type: WBaseProperty.Z_INDEX, start: -1, end: -1 }))
      .animDuration(300).animCurve(CapConst.CAPSULE_REMIND_ANIM_OUT_CURVE);
    let out = new ImmersiveBaseAnim(scene).addAnimUnit(firstUnit).addAnimUnit(secondUnit).addAnimState(rootState);

    firstUnit = new ImmersiveAnimUnit()
      .addAnimNode(new ImmersiveAnimNode(remindState)
        .addPropValue({ type: WBaseProperty.SCALE_X, start: 1.05, end: 1 })
        .addPropValue({ type: WBaseProperty.SCALE_Y, start: 1.05, end: 1 })
        .addPropValue({
          type: WBaseProperty.TRAN_Y, start: CapConst.CAPSULE_HEIGHT +
          CapConst.CAPSULE_REMIND_ANIM_END_SPACE - CapConst.STACKED_DISTANCE, end: 0
        })
        .addPropValue({ type: WBaseProperty.Z_INDEX, start: 1, end: 1 }))
      .addAnimNode(new ImmersiveAnimNode(hideState)
        .addPropValue({ type: WBaseProperty.SCALE_X, start: 1.0, end: 0.94 })
        .addPropValue({ type: WBaseProperty.TRAN_Y, start: 0, end: CapConst.STACKED_DISTANCE })
        .addPropValue({ type: WBaseProperty.ALPHA, start: 1.0, end: 0 }))
      .addAnimNode(new ImmersiveAnimNode(shadowState)
        .addPropValue({ type: WBaseProperty.ALPHA, start: 0, end: 1.0 }))
      .animCurve(CapConst.CAPSULE_REMIND_ANIM_BACK_CURVE);
    let back = new ImmersiveBaseAnim(scene).addAnimUnit(firstUnit).addAnimState(rootState);
    this.sceneAnimations.set(scene, new ImmersiveSerialAnim(scene).addBaseAnim(out).addBaseAnim(back));
  }
}