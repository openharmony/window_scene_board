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
import { ListWgBindStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { BlurFreezeScene } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { immersiveStateHelper } from '../../common/helper/ImmersiveStateHelper';
import { ImmersiveAnimKey, ImmersiveAnimScene } from '../../common/anim/ImmersiveAnimConstants';


const TAG = 'ImmersiveAnimSceneManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 动效结束类型
 */
type OnAnimFinish = () => void;
type OnAnimPre = () => void;
export type OnAnimFinishCallback = (scene: ImmersiveAnimScene) => void;


const animInterSceneMap: Map<ImmersiveAnimKey, ImmersiveAnimScene[]> = new Map([
  // 列表为起点
  [ImmersiveAnimKey.IMMERSIVE_LIST_ROOT, [
    ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX,
    ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH_BACK,
    ImmersiveAnimScene.SCENE_CARD_TO_LIST
  ]],
  // 胶囊动效起始点
  [ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT, [
    ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX,
    ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE,
    ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH_BACK
  ]],
  // 沉浸态为起点
  [ImmersiveAnimKey.IMMERSIVE_CARD_ROOT, [
    ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX,
    ImmersiveAnimScene.SCENE_LIST_TO_CARD,
    ImmersiveAnimScene.SCENE_CAPSULE_TO_CARD,
  ]],
]);

export class AnimFinishInfo {

  /**
   * 动效结束回调
   */
  public onAnimFinish?: OnAnimFinish;

  /**
   * 唯一key，用于解决相同场景动效打断问题
   */
  public key?: string;
}

/**
 * 动效的场景状态管理
 */
export class ImmersiveAnimStateManager {
  /**
   * 动效中场景缓存
   */
  private animatingScene: Map<ImmersiveAnimScene | undefined, Set<AnimFinishInfo | undefined>> = new Map();

  /**
   * 动效前置状态管理
   */
  private scenePreProcessing: Map<ImmersiveAnimKey | undefined, Set<OnAnimPre | undefined>> = new Map();

  private finishedListener: Set<OnAnimFinishCallback> = new Set();

  public registerFinishedListener(listener: OnAnimFinishCallback): void {
    this.finishedListener.add(listener);
  }

  constructor() {
    // 列表到胶囊动效前
    animInterSceneMap.forEach((values, key) => {
      this.addAnimScenePreProcessing(key, () => {
        values?.forEach((scene) => {
          this.exeAnimSceneFinish(scene);
        })
      });
    })
  }

  public addAnimScenePreProcessing(scene?: ImmersiveAnimKey, preProcessing?: OnAnimPre): void {
    let preSet = this.scenePreProcessing.get(scene);
    if (CommonUtils.isInvalid(preSet)) {
      preSet = new Set();
      this.scenePreProcessing.set(scene, preSet);
    }
    preSet?.add(preProcessing);
  }

  public exeAnimScenePreProcessing(scene?: ImmersiveAnimKey): void {
    this.scenePreProcessing.get(scene)?.forEach((preProcessing) => {
      preProcessing?.();
    });
  }

  /**
   * 缓存动效场景结束回调
   *
   * @param scene 动效场景
   * @param finish 结束回调
   */
  public addAnimSceneFinish(scene?: ImmersiveAnimScene, finish?: AnimFinishInfo): void {
    let finishSet = this.animatingScene.get(scene);
    if (CommonUtils.isInvalid(finishSet)) {
      finishSet = new Set();
      this.animatingScene.set(scene, finishSet);
    }
    finishSet?.add(finish);
  }

  /**
   * 移除动效场景结束回调
   *
   * @param scene 动效场景
   * @param finish 结束回调
   */
  public removeAnimSceneFinish(scene?: ImmersiveAnimScene, finish?: AnimFinishInfo): void {
    let finishSet = this.animatingScene.get(scene);
    finishSet?.delete(finish);
    if (ArrayUtils.isEmpty(finishSet)) {
      this.animatingScene.delete(scene);
    }
  }

  /**
   * 是否动效场景未finish
   *
   * @param scene 动效场景
   * @returns true动效中
   */
  public hasAnimSceneFinish(scene?: ImmersiveAnimScene): boolean {
    return this.animatingScene.has(scene);
  }

  /**
   * 执行动效结束回调
   *
   * @param scene 动效场景
   */
  public exeAnimSceneFinish(scene?: ImmersiveAnimScene, key?: string): void {
    let isHasFinish: boolean = false;
    this.animatingScene.get(scene)?.forEach((finish) => {
      if (!key || key && key === finish?.key) {
        isHasFinish = true;
        finish?.onAnimFinish?.();
      }
    });
    if (!isHasFinish) {
      log.showInfo(`not exist animFinish callback : ${key}`);
      return;
    }

    if (scene !== undefined && this.animatingScene.get(scene) !== undefined) {
      for (let listener of this.finishedListener) {
        listener?.(scene);
      }
    }
    this.animatingScene.delete(scene);
  }

  /**
   * 设置模糊冻结状态
   *
   * @param isFreeze true冻结模糊
   * @param scene 动效场景
   */
  public setBlurFreezeState(isFreeze: boolean, scene?: ImmersiveAnimScene): void {
    let freeze: BlurFreezeScene = { isFreeze: isFreeze, scene: scene };
    immersiveStateHelper.getSlListBindState()?.setSlState(ListWgBindStateType.BG_BLUR_FREEZE, freeze);
  }
}