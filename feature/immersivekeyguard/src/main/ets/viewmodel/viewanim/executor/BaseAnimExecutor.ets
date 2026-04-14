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
import { CmpPosWrapper, ImmersiveLiveAnimSceneEnum } from '@ohos/screenlockcommon/Index';
import { LimitMap } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/utils/LimitMap';
import { CmpStateWrapper } from '../../../common/helper/ComponentTransformHelper';

const TAG = 'BaseAnimExecutor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

type ActionEvent = () => void;
const MAX_CMP_COUNT = 100;
const DEFAULT_SCENE = 'default_scene';
const STATE_MAP = TAG + '_StateMap';
const POS_MAP = TAG + '_PosMap';

/**
 * 抽象动效执行器
 */
export abstract class BaseAnimExecutor {
  /**
   * 动效数据关键标识
   */
  protected keyCode?: string;
  /**
   * 动效场景
   */
  protected scene: string = DEFAULT_SCENE;
  /**
   * 是否动效中
   */
  protected isAnim: boolean = false;
  /**
   * 动效方向
   */
  protected isForward: boolean = true;
  /**
   * 前置动作
   */
  protected preAction?: ActionEvent;
  /**
   * 后置动作
   */
  protected afterAction?: ActionEvent;
  /**
   * 组件状态
   */
  private cmpStateMap: LimitMap<string, CmpStateWrapper> = new LimitMap(STATE_MAP, MAX_CMP_COUNT);
  /**
   * 组件位置
   */
  private cmpPosMap: LimitMap<string, CmpPosWrapper> = new LimitMap(POS_MAP, MAX_CMP_COUNT);

  constructor(scene: ImmersiveLiveAnimSceneEnum) {
    this.scene = scene;
  }

  /**
   * 动效实现
   */
  abstract animate(): void;

  /**
   * 动效信息组装
   */
  abstract complementAnimInfo(): void;

  /**
   * 检查动效条件是否有效
   *
   * @returns 是否有效布尔值
   */
  public checkCondition(): boolean {
    if (this.cmpPosMap.size() === 0 || this.cmpStateMap.size() === 0) {
      log.showWarn(`${this.scene} anim cmp size not satisfied`);
      return false;
    }

    this.cmpStateMap.forEach((value, key) => {
      if (!value) {
        log.showError(`anim state: ${key} is invalid`);
        throw new Error('anim info exists invalid value');
      }
    })
    let positionValidFlg = false;
    this.cmpPosMap.forEach((value, key) => {
      if (value && value.isPosValid()) {
        positionValidFlg = true;
        log.showInfo(`${this.scene} anim condition success pos:${this.cmpPosMap.size()}  state:${this.cmpStateMap.size()}`);
        return;
      }
    })

    if (!positionValidFlg) {
      log.showError(`anim position: all is invalid`);
      throw new Error('anim info exists invalid value');
    }
    return positionValidFlg ? true : false;
  }

  /**
   * 动效执行入口
   *
   * @param isForward 是否正向执行
   */
  public exec(isForward: boolean = true): void {
    this.isForward = isForward;
    this.complementAnimInfo();
    if (this.validationCondition()) {
      this.preAnim();
      this.animate();
    } else {
      this.resetAnim();
    }
  }

  /**
   * 动效前处理
   */
  public preAnim(): void {
    log.showInfo(`${this.scene} anim isForward:${this.isForward} start`);
    this.isAnim = true;
    this.preAction?.();
    this.setAnimState(true);
  }

  /**
   * 动效后处理
   */
  public afterAnim(): void {
    if (!this.isAnim) {
      return;
    }
    this.afterAction?.();
    this.clearAnimState();
    this.setAnimState(false);
    this.resetAnim();
    this.isAnim = false;
    log.showInfo(`${this.scene} anim end`);
  }

  /**
   * 放置组件位置信息
   */
  public putPosInfo(key: string, info: CmpPosWrapper) {
    this.cmpPosMap.set(key, info);
  }

  /**
   * 放置动效状态信息
   */
  public putStateInfo(key: string, info: CmpStateWrapper) {
    this.cmpStateMap.set(key, info);
  }

  /**
   * 得到动效状态信息
   */
  public getStateInfo(key: string): CmpStateWrapper | undefined {
    return this.cmpStateMap.get(key);
  }

  /**
   * 得到组件位置信息
   */
  public getPosInfo(key: string): CmpPosWrapper | undefined {
    return this.cmpPosMap.get(key);
  }

  /**
   * 设置动效前置动作
   *
   * @param action 前置动作函数
   */
  public setPreAction(action?: ActionEvent): void {
    this.preAction = action;
  }

  /**
   * 设置动效后置动作
   *
   * @param action 后置动作函数
   */
  public setAfterAction(action?: ActionEvent): void {
    this.afterAction = action;
  }

  /**
   * 设置动效数据唯一标识
   *
   * @param key 动效数据的hashcode
   */
  public setKeyCode(key: string | undefined): BaseAnimExecutor {
    this.keyCode = key;
    return this;
  }

  private setAnimState(isAnimating: boolean): void {
    for (let entry of this.cmpStateMap.values()) {
      entry?.setAnimating(isAnimating, this.scene);
    }
  }

  private resetAnim(): void {
    this.isForward = true;
    this.preAction = undefined;
    this.afterAction = undefined;
    this.cmpStateMap.clear();
    this.cmpPosMap.clear();
  }

  private clearAnimState(): void {
    for (let entry of this.cmpStateMap.values()) {
      entry?.clearAnimState();
    }
  }

  private validationCondition(): boolean {
    if (!this.keyCode) {
      log.showWarn('validationCondition keyCode is undefined');
    }
    let res = false;
    try {
      res = this.checkCondition();
    } catch (e) {
      log.error(`scene:${this.scene} isForward:${this.isForward} condition invalid`)
      return false;
    }
    return res;
  }
}