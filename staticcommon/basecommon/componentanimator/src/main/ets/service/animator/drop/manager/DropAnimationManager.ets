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

import {
  animationResult,
  MultiAnimationParam,
  DropAnimationParam,
  DropAnimationExParam
} from '../bean/DropAnimationParam';
import {
  DropAnimationCancelReason,
  DropAnimationConfig,
  DropAnimationScene,
  DropAnimationDestination,
} from '../config/DropAnimationConfig';
import { DropItemViewModel } from '../viewmodel/DropItemViewModel';
import {
  LogDomain,
  LogHelper,
  SingletonHelper,
  CheckEmptyUtils,
  SingleBase,
  SingleContext,
  singleManager
} from '@ohos/basicutils';
import { dropAnimationObserver } from '../observer/DropAnimationObserver';
import { AnimationViewData, AnimationViewDataList } from '../../common/viewmodel/AnimationViewData';
import { FrameAnimationParam } from '../bean/FrameAnimationParam';
import { DropAnimationTsAdapter } from '../adapter/DropAnimationTsAdapter';

const TAG: string = 'DropAnimationManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 落位动效管理类
 */
class DropAnimationManager extends SingleBase {
  private dropItemViewModelMap: Map<DropAnimationScene, Map<string, DropItemViewModel>> = new Map();
  private dropItemArrayMap: Map<DropAnimationScene, AnimationViewDataList> = new Map();

  public constructor(ctx?: SingleContext) {
    super(ctx);
    this.initTsAdapter();
  }

  static getInstance(ctx?: SingleContext): DropAnimationManager {
    return singleManager.get<DropAnimationManager>(DropAnimationManager, ctx);
  }

  private initTsAdapter(): void {
    DropAnimationTsAdapter.cancelFunc = (reason: DropAnimationCancelReason) => this.cancelDropAnimation(reason);
  }

  /**
   * 设置落位元素的数组
   *
   * @param scene 落位动效场景
   * @param dropItems 落位元素数组
   */
  public addDropItemArray(scene: DropAnimationScene, dropItems: AnimationViewDataList): void {
    log.showInfo(`addDropItemArray scene:${scene}`);
    this.dropItemArrayMap.set(scene, dropItems);
  }

  /**
   * 移除对应场景的落位元素信息
   *
   * @param scene 落位动效场景
   */
  public removeDropItemArray(scene: DropAnimationScene): void {
    log.showInfo(`removeDropItemArray scene:${scene}`);
    this.dropItemViewModelMap.delete(scene);
    this.dropItemArrayMap.delete(scene);
  }

  /**
   * 移除对应场景的落位元素信息并且release
   *
   * @param scene 落位动效场景
   */
  public releaseAllItemInScene(scene: DropAnimationScene): void {
    log.showInfo(`releaseAllItemInScene scene:${scene}`);
    this.dropItemViewModelMap.get(scene)?.forEach(item =>{
      item.clearDropData();
    })
    this.dropItemViewModelMap.delete(scene);
  }

  /**
   * 获取落位动效场景的数量
   *
   * @returns 落位动效场景的数量
   */
  public getDropAnimationSceneCount(): number {
    return this.dropItemArrayMap.size;
  }

  /**
   * 获取落位动效元素的数量
   *
   * @param scene 落位动效场景
   * @returns 落位动效元素的数量
   */
  public getDropItemCount(scene: DropAnimationScene): number {
    return this.dropItemViewModelMap.get(scene)?.size ?? 0;
  }

  /**
   * 获取落位元素的属性管理类
   *
   * @param scene 落位动效场景
   * @param key 落位元素的标识符
   * @returns 落位元素的属性管理类
   */
  public getDropViewModel(scene: DropAnimationScene, key: string): DropItemViewModel | undefined {
    log.showInfo(`getDropViewModel scene:${scene} key:${key}`);
    if (!this.dropItemArrayMap.has(scene) || CheckEmptyUtils.isEmpty(key)) {
      return undefined;
    }
    let map = this.dropItemViewModelMap.get(scene);
    if (map == null) {
      map = new Map();
      this.dropItemViewModelMap.set(scene, map);
    }
    log.showInfo(`getDropViewModel mapSize:${map.size} arraySize:${this.dropItemArrayMap.get(scene)?.length}`);
    let dropItemViewModel = map.get(key);
    if (dropItemViewModel == null) {
      let viewData: AnimationViewData = new AnimationViewData(key);
      dropItemViewModel = new DropItemViewModel(viewData);
      map.set(key, dropItemViewModel);
      this.dropItemArrayMap.get(scene)?.push(viewData);
    }
    return dropItemViewModel;
  }

  /**
   * 清空落位元素
   */
  public clear(): void {
    log.showInfo(`clear all drop item`);
    this.dropItemViewModelMap.clear();
    this.dropItemArrayMap.forEach((value: AnimationViewDataList) => value.splice(0, value.length));
  }

  /**
   * 移除单个落位元素
   *
   * @param scene 落位动效场景
   * @param key 落位元素标识符
   */
  public removeDropItem(scene: DropAnimationScene, key: string): void {
    log.showInfo(`removeDropItem scene:${scene} key:${key}`);
    this.dropItemViewModelMap.get(scene)?.delete(key);
    let dropItemArray = this.dropItemArrayMap.get(scene);
    if (!dropItemArray) {
      return;
    }
    let index = dropItemArray.findIndex((value) => value.key === key);
    if (index >= 0) {
      dropItemArray.splice(index, 1);
    }
  }

  /**
   * 开始落位动效
   *
   * @param target 落位动效终点位置
   * @param param 落位动效参数
   * @param onDropAnimationEnd 落位动效执行完的回调，回调参数为动效是否被取消和执行动效的参数
   * @returns 是否成功开启动效
   */
  public startDropAnimation(target: DropAnimationDestination, param: DropAnimationParam,
    onDropAnimationEnd?: (isCancel: boolean, param: DropAnimationParam) => void): boolean {
    if (CheckEmptyUtils.isEmpty(param.key)) {
      return false;
    }
    log.showInfo(`startDropAnimation target:${target} key:${param.key}`);
    let scene = DropAnimationConfig.getDropAnimationScene(target);
    let res = this.dropItemViewModelMap.get(scene)?.get(param.key)?.startAnimation(param, target, param.delay,
      (isCancel: boolean) => {
        this.removeDropItem(scene, param.key);
        onDropAnimationEnd?.(isCancel, param);
        dropAnimationObserver.triggerAnimationEnd(target, param, false, isCancel);
    });
    if (res) {
      dropAnimationObserver.triggerAnimationStart(target, param, false);
    }
    return res ?? false;
  }

  /**
   * 开始多个动效
   * @param target 落位动效终点位置
   * @param param 落位动效参数
   * @param onDropAnimationEnd 落位动效执行完的回调，回调参数为动效是否被取消和执行动效的参数
   * @returns 是否成功开启动效
   */
  public startMultiDropAnimation(params: MultiAnimationParam): boolean {
    if ((params.paramList ?? []).length === 0) {
      return false;
    }
    log.showInfo(`startMultiDropAnimation target:${params.target}`);
    const scene = DropAnimationConfig.getDropAnimationScene(params.target);
    if (params.paramList instanceof DropAnimationParam) {
      dropAnimationObserver.triggerAnimationStart(params.target, params.paramList[0] as DropAnimationParam, true);
    }
    const animationList = params.paramList
      .map((param: DropAnimationParam | DropAnimationExParam) => {
        return new Promise<animationResult>((resolve) => {
          params.onAnimationItemStart?.(param);
          this.dropItemViewModelMap.get(scene)?.get(param.key)?.startAnimationAsync(
            param, params.target, params.releaseOnEnd, (param as DropAnimationParam).delay
          ).then((res: animationResult) => {
            const isCancel = res === animationResult.CANCEL || res === animationResult.NOT_START;
            params.onAnimationItemEnd?.(param, isCancel);
            resolve(res);
          })
        })
      })
      .filter(x => x) as Promise<animationResult>[];
    Promise.all(animationList)
      .then((resList: animationResult[]) => {
        const isCancel = resList[0] === animationResult.CANCEL
        params.onAnimationEnd?.(isCancel, params.paramList);
        if (params.releaseOnEnd) {
          let len = params.paramList.length
          for (let i = 0; i < len; i++) {
            const param = params.paramList[i];
            this.dropItemViewModelMap.get(scene)?.get(param.key)?.clearDropData();
            this.removeDropItem(scene, param.key);
          }
        }
        if (params.paramList instanceof DropAnimationParam) {
          dropAnimationObserver.triggerAnimationEnd(
            params.target,
            params.paramList[0] as DropAnimationParam,
            true,
            isCancel
          );
        }
      })
    return true;
  }

  /**
   * 开始自定义帧动效
   * @param target 落位动效终点位置
   * @param param 落位动效参数
   * @param onDropAnimationEnd 落位动效执行完的回调，回调参数为动效是否被取消和执行动效的参数
   * @returns 是否成功开启动效
   */
  public startCustomFrameAnimation(
    target: DropAnimationDestination,
    params: FrameAnimationParam[],
    onAnimationEnd?: (isCancel: boolean) => void,
    releaseOnEnd: boolean = true,
  ): boolean {
    const scene = DropAnimationConfig.getDropAnimationScene(target);
    log.showInfo(`startCustomFrameAnimation scene ${scene}`);
    const viewModels = this.dropItemViewModelMap.get(scene);
    if (!viewModels) {
      return false;
    }
    let paramsGroupByViewModel: Map<string, FrameAnimationParam[]> = new Map();
    params.forEach(item => {
      let group = paramsGroupByViewModel.get(item.id);
      if (!Array.isArray(group)) {
        group = [];
      }
      group.push(item);
      paramsGroupByViewModel.set(item.id, group);
    });

    const animationList: Promise<animationResult>[] = [];
    paramsGroupByViewModel.forEach(async (params: FrameAnimationParam[], id: string) => {
      const viewModel = viewModels.get(id);
      if (!viewModel) {
        return;
      }
      let promise = viewModel.startFrameAnimation(target, params, releaseOnEnd);
      if (promise) {
        animationList.push(promise);
      }
    })
    Promise.all(animationList).then((resList: animationResult[]) => {
      const isCancel: boolean = resList[0] === animationResult.CANCEL;
      onAnimationEnd?.(isCancel);
    })
    return true;
  }

  /**
   * 准备落位动效元素，让落位动效组件上树，一般在热区的onDragEnter中调用，与onDragStart错开，提升性能
   * 当key为空时，准备对应场景的所有落位动效组件，当key非空时，准备key对应的落位动效组件
   *
   * @param target 落位动效终点位置
   * @param key 落位元素的标识符
   */
  public prepareDropItem(target: DropAnimationDestination, key?: string): void {
    log.showInfo(`prepareDropItem target:${target} key:${key}`);
    let map = this.dropItemViewModelMap.get(DropAnimationConfig.getDropAnimationScene(target));
    if (map == null) {
      return;
    }
    if (key == null) {
      map.forEach((value: DropItemViewModel) => value.loadSnapshot());
      return;
    } else {
      map.get(key)?.loadSnapshot();
    }
  }

  /**
   * 取消落位动效
   * @param reason 落位动效取消的原因
   * @param release 是否在动效取消后释放动效组件
   */
  public cancelDropAnimation(reason: DropAnimationCancelReason, release: boolean = true): void {
    log.showInfo(`cancelDropAnimation reason:${reason} release:${release}`);
    try {
      this.dropItemViewModelMap.forEach((map) => {
        map.forEach((value) => {
          value.cancelAnimation(reason, release);
        });
      });
    } catch (err) {
      log.showError(`cancelDropAnimation error: ${err}`);
    }
  }

  /**
   * 是否在落位动效过程中，当key非空时返回key对应的元素是否正在执行落位动效，当key为空时只要有元素正在执行落位动效就返回true
   *
   * @param scene 落位动效场景
   * @param key 落位元素的标识符
   * @returns 是否在落位动效过程中
   */
  public isInDropAnimation(scene: DropAnimationScene, key?: string): boolean {
    log.showInfo(`isInDropAnimation scene:${scene} key:${key}`);
    let map = this.dropItemViewModelMap.get(scene);
    if (map == null) {
      return false;
    }
    if (key == null) {
      for (const dropViewModel of map.values()) {
        if (dropViewModel.isInAnimation()) {
          log.showInfo(`isInDropAnimation true`);
          return true;
        }
      }
      return false;
    }
    const isAnimation: boolean = map.get(key)?.isInAnimation() ?? false;
    log.showInfo(`isInDropAnimation ${isAnimation}`);
    return isAnimation;
  }

  public hideAnimationItemByScene(scene: DropAnimationScene, isImmediately: boolean = false): void {
    if (isImmediately) {
      animateToImmediately({duration: 0}, () => {
        this.dropItemArrayMap.get(scene)?.forEach(item => {
          item.isShow = false;
        })
      })
    } else {
      animateTo({duration: 0}, () => {
        this.dropItemArrayMap.get(scene)?.forEach(item => {
          item.isShow = false;
        })
      })
    }
  }

  /**
   * 更新动效重点位置 仅供多选拖拽动效使用
   * @param scene
   * @param position
   */
  public updateAnimationTargetPosition(scene: DropAnimationScene, position: Position): void {
    this.dropItemViewModelMap.get(scene)?.forEach(item => {
      item.updateFrameAnimation([{
        animationId: 'position',
        targets: [Number(position.x), Number(position.y)]
      }])
    })
  }
}

export const dropAnimationManager: DropAnimationManager = SingletonHelper.getInstance(DropAnimationManager, TAG);
