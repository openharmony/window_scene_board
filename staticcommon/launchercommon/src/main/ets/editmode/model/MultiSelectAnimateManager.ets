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
  AnimationViewData,
  DropAnimationCancelReason,
  DropAnimationConfig,
  DropAnimationDestination,
  DropAnimationParam,
  DropAnimationScene,
  DropAnimationExParam,
} from '@ohos/componentanimator';
import { LogDomain, LogHelper, SingletonHelper, AnimateToScheduleUtils } from '@ohos/basicutils';
import { DragConstants } from '@ohos/commonconstants';
import { FrameSetTimeout } from '@ohos/componenthelper';
import {
  folderLayoutUtil,
  multiSelectListenManger,
  MultiSelectManager,
  StyleConfig,
  ListenerItemType,
} from '../../TsIndex';
import {
  cancelAnimationType,
  doDropAnimateType,
  DoDropToFolderAnimateType,
  doGatherAnimateType,
  AnimationType,
  GatherAnimateItem,
  GatherAnimateTarget,
  preLoadAnimationViewType,
  updateAnimationTargetType} from '../data/MultiSelectData';
import { dropAnimationManager, DropItemViewModel, FrameAnimationParam } from '@ohos/componentanimator/Index';
import { MultiSelectStyleConfig } from '../data/MultiSelectStyleConfig';
import Curves from '@ohos.curves';

const TAG: string = 'MultiSelectAnimateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class MultiSelectAnimateManager {
  private readonly scene: DropAnimationScene = MultiSelectStyleConfig.ANIMATION_SCENE;
  private readonly target: DropAnimationDestination = DropAnimationDestination.MULTI_SELECT;

  constructor() {
    multiSelectListenManger.register({
      id: multiSelectListenManger.getListenerId(ListenerItemType.MULTISELECT_ANIMATE_MANAGER, ''),
      onEnter: (): void => {
        log.showInfo('set animating');
        MultiSelectManager.getInstance().preLoadAnimationView = this.preLoadAnimationView;
        MultiSelectManager.getInstance().doGatherAnimate = this.doGatherAnimate;
        MultiSelectManager.getInstance().doDropAnimate = this.doDropAnimate;
        MultiSelectManager.getInstance().doDropToFolderAnimate = this.doDropToFolderAnimate;
        MultiSelectManager.getInstance().releaseAnimateItem = this.releaseAnimateItem;
        MultiSelectManager.getInstance().hideAnimationItem = this.hideAnimationItem;
        MultiSelectManager.getInstance().cancelAnimation = this.cancelAnimation;
        MultiSelectManager.getInstance().updateAnimationTarget = this.updateAnimationTarget;
        MultiSelectManager.getInstance().resetDropAnimationItemZIndex = this.resetDropAnimationItemZIndex;
        MultiSelectManager.getInstance().resetDropAnimationItemOpacity = this.resetDropAnimationItemOpacity;
      }
    })
  }

  private animationItemMap: Map<string, DropItemViewModel> = new Map();

  private preLoadAnimationView: preLoadAnimationViewType = (list: GatherAnimateItem[]): void => {
    this.animationItemMap.clear();
    // 按从上到下的顺序
    list.sort((a, b) => (b.zIndex ?? 1) - (a.zIndex ?? 1) ).forEach(item => {
      this.createAnimationItem(item);
    })
    dropAnimationManager.prepareDropItem(this.target);
  }

  private doGatherAnimate: doGatherAnimateType = async (targetList: GatherAnimateTarget[]) => {
    const isCancel: boolean = await new Promise((resolve) => {
      log.showInfo('doGatherAnimate');
      MultiSelectManager.getInstance().inAnimation = true;
      let frameSetTimeout = new FrameSetTimeout();
      const setTimeoutId = frameSetTimeout.start(() => {
        resolve(false);
      }, MultiSelectStyleConfig.getGatherDuration() + MultiSelectStyleConfig.ROTATE_DURATION);
      this.gatherAnimation(targetList).then((isCancel: boolean) => {
        frameSetTimeout.clear(setTimeoutId);
        resolve(isCancel);
      })
    })
    MultiSelectManager.getInstance().inAnimation = false;
    log.showInfo('gather animation end');
    return isCancel;
  }

  private gatherAnimation(targetList: GatherAnimateTarget[]): Promise<boolean> {
    return new Promise((resolve) => {
      let animationParamList: FrameAnimationParam[] = [];
      targetList.forEach((target: GatherAnimateTarget, index: number) => {
        animationParamList.push(...this.getGatherAnimationParams(target));
        animationParamList.push(...this.getRotateAnimationParams(target, index));
      })
      MultiSelectManager.getInstance().inAnimation = true;
      AnimateToScheduleUtils.raiseAnimateToGCPriority(0);
      let startCustomFrameAnimationResult: boolean = dropAnimationManager.startCustomFrameAnimation(
        this.target,
        animationParamList,
        (isCancel) => {
          AnimateToScheduleUtils.raiseAnimateToGCPriority(1);
          MultiSelectManager.getInstance().inAnimation = false;
          resolve(isCancel);
        },
        false
      )
      log.showInfo(`gatherAnimation startCustomFrameAnimationResult: ${startCustomFrameAnimationResult}`);
    })
  }

  private getGatherAnimationParams(target: GatherAnimateTarget): FrameAnimationParam[] {
    return [
      {
        id: target.parentId,
        animationId: 'position',
        delay: 0,
        duration: MultiSelectStyleConfig.getGatherDuration(),
        endDelay: MultiSelectStyleConfig.ROTATE_DURATION,
        curves: MultiSelectStyleConfig.GATHER_ANIMATE_CURVE,
        begins: [target.startPosition.x, target.startPosition.y],
        targets: [target.endPosition.x, target.endPosition.y],
        onRender: (viewData: AnimationViewData, currentVal: number[]) => {
          viewData.translateX = currentVal[0];
          viewData.translateY = currentVal[1];
        }
      },
      {
        id: target.parentId,
        animationId: 'scale',
        delay: 0,
        endDelay: 0,
        curves: MultiSelectStyleConfig.GATHER_ANIMATE_SCALE_CURVE,
        duration: MultiSelectStyleConfig.getGatherDuration(),
        begins: [target.scale],
        targets: [DragConstants.DROP_START_SCALE],
        onRender: (viewData: AnimationViewData, currentVal: number[]) => {
          viewData.scaleX = currentVal[0];
          viewData.scaleY = currentVal[0];
        }
      }
    ];
  }

  private getRotateAnimationParams(target: GatherAnimateTarget, index: number): FrameAnimationParam[] {
    const rotateAnimation: FrameAnimationParam = {
      id: target.parentId,
      animationId: 'rotate',
      delay: MultiSelectStyleConfig.getGatherDuration(),
      endDelay: 0,
      curves: MultiSelectStyleConfig.GATHER_ANIMATE_SCALE_CURVE,
      duration: MultiSelectStyleConfig.ROTATE_DURATION,
      begins: [0],
      targets: [0],
      onRender: (viewData: AnimationViewData, currentVal: number[]) => {
        viewData.rotate.angle = currentVal[0];
      }
    };
    const opacityAnimation: FrameAnimationParam = {
      id: target.parentId,
      animationId: 'opacity',
      endDelay: 0,
      delay: MultiSelectStyleConfig.getGatherDuration(),
      curves: MultiSelectStyleConfig.GATHER_ANIMATE_SCALE_CURVE,
      duration: MultiSelectStyleConfig.ROTATE_DURATION,
      begins: [1],
      targets: [0],
      onRender: (viewData: AnimationViewData, currentVal: number[]) => {
        viewData.opacity = currentVal[0];
      }
    };
    switch (index) {
      case 0:
      default:
        opacityAnimation.targets = [MultiSelectStyleConfig.FIRST_ICON_OPACITY];
        break;
      case 1:
        rotateAnimation.delay += MultiSelectStyleConfig.ROTATE_DELAY;
        opacityAnimation.delay += MultiSelectStyleConfig.ROTATE_DELAY;
        rotateAnimation.targets = [MultiSelectStyleConfig.ROTATE_ANGLES];
        opacityAnimation.targets = [MultiSelectStyleConfig.SECOND_ICON_OPACITY];
        break;
      case 2:
        rotateAnimation.delay += MultiSelectStyleConfig.ROTATE_DELAY * 2;
        opacityAnimation.delay += MultiSelectStyleConfig.ROTATE_DELAY * 2;
        rotateAnimation.targets = [-1 * MultiSelectStyleConfig.ROTATE_ANGLES];
        opacityAnimation.targets = [MultiSelectStyleConfig.THIRD_ICON_OPACITY];
        break;
    }
    return [rotateAnimation, opacityAnimation];
  }

  private doDropAnimate: doDropAnimateType = async (targetList, onItemFinish) => {
    log.showInfo('doDropAnimate');
    let animateParamList: DropAnimationParam[] = [];
    targetList.forEach((item: GatherAnimateTarget, index: number) => {
      const animationParam = this.createAnimationParam(item);
      animationParam.endOpacity = 1;
      animateParamList.push(animationParam);
    });
    const isDropCancel = await this.doAnimation(animateParamList, true, (param) => {
      onItemFinish(param.key);
    });
    if (isDropCancel) {
      log.showInfo('dropAnimation cancel');
    }
    this.animationItemMap.clear();
    dropAnimationManager.releaseAllItemInScene(this.scene);
    return isDropCancel;
  }

  /**
   * 在多选进文件夹落位动效中将首页最后一个显示的图标zIndex置底，以满足UX对后续图标的动效设计
   * @param key 需修改的图标key
   */
  private resetDropAnimationItemZIndex = (key: string) => {
    dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_MULTI_SELECT, key)?.setZIndex(0);
  }

  /**
   * 在多选进文件夹落位动效中重设显示的图标opacity
   * @param key 需修改的图标key
   * @param opacity 透明度 0 - 1
   */
  private resetDropAnimationItemOpacity = (key: string, opacity: number) => {
    dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_MULTI_SELECT, key)?.setOpacity(opacity);
  }

  /**
   * 不同场景下多选落位文件夹动效参数设置
   * @param targetList 需落位的图标信息
   * @param onItemFinish 落位完成的回调
   * returns 落位动效执行是否完成
   */
  private doDropToFolderAnimate: DoDropToFolderAnimateType =
    async (targetList, onItemFinish) => {
      let animateParamList: DropAnimationExParam[] = [];
      targetList.forEach((item: GatherAnimateTarget, index: number) => {
        const animationParam = this.createAnimationExParam(item);
        animationParam.eventList = [
          {
            delay: item.delay,
            curve: Curves.interpolatingSpring(0, 1, 247, 25),
            endX: item.endPosition.x,
            endY: item.endPosition.y,
          },
          {
            delay: item.delay,
            curve: Curve.Linear,
            duration: 300,
            endScaleX: item.scale,
            endScaleY: item.scale,
            endRotate: { angle: 0 },
          }
        ];
        if (item.animationType === AnimationType.FADE_DROP) {
          animationParam.eventList.push({
            delay: (item.delay ?? 0) + 150,
            curve: Curve.Friction,
            duration: 150,
            endOpacity: 0,
          });
        } else if (item.animationType === AnimationType.REVERT_FADE_DROP) {
          animationParam.type = AnimationType.REVERT_FADE_DROP
          animationParam.eventList.push({
            delay: item.delay,
            curve: Curve.Friction,
            duration: 150,
            endOpacity: 1,
          });
          animationParam.eventList.push({
            delay: (item.delay ?? 0) + 150,
            curve: Curve.Friction,
            duration: 150,
            endOpacity: 0,
          });
        } else if (item.animationType === AnimationType.DROP) {
          animationParam.eventList.push({
            delay: item.delay,
            curve: Curve.Friction,
            duration: 300,
            endOpacity: 1,
          });
        }
        animateParamList.push(animationParam);
      })
    const isDropCancel = await this.doAnimation(animateParamList, false, (param) => {
      onItemFinish(param.key);
    });
    if (isDropCancel) {
      log.showInfo('dropAnimation cancel');
    }
    this.animationItemMap.clear();
    dropAnimationManager.releaseAllItemInScene(this.scene);
    return isDropCancel;
  }

  private releaseAnimateItem = (): void => {
    dropAnimationManager.releaseAllItemInScene(this.scene);
  }

  /**
   * // 设置动效组件
   * @param gatherItem
   */
  private createAnimationItem(gatherItem: GatherAnimateItem): void {
    const animationItem = dropAnimationManager.getDropViewModel(this.scene, gatherItem.parentId) as DropItemViewModel;
    animationItem
      .setWidth(gatherItem.width)
      .setHeight(gatherItem.width)
      .setDropSnapshot(gatherItem.image)
      .setScale(gatherItem.scale)
      .setRadius(gatherItem.radius)
      .setZIndex(gatherItem.zIndex ?? 1)
    this.animationItemMap.set(gatherItem.parentId, animationItem)
  }

  private createAnimationParam(gatherTarget: GatherAnimateTarget): DropAnimationParam {
    const animationParam = new DropAnimationParam(
      gatherTarget.parentId,
      gatherTarget.startPosition.x,
      gatherTarget.startPosition.y,
      gatherTarget.endPosition.x,
      gatherTarget.endPosition.y
    );
    animationParam.endScaleX = gatherTarget.scale;
    animationParam.endScaleY = gatherTarget.scale;
    animationParam.delay = gatherTarget.delay ?? 0;
    return animationParam;
  }

  /**
   * 初始化文件夹落位动效参数
   * @param gatherTarget 汇聚起来的某一个图标对象
   * returns 初始文件夹落位动效参数
   */
  private createAnimationExParam(gatherTarget: GatherAnimateTarget): DropAnimationExParam {
    const animationParam = new DropAnimationExParam(
      gatherTarget.parentId,
      gatherTarget.startPosition.x,
      gatherTarget.startPosition.y,
      [
        {
          endX: gatherTarget.endPosition.x,
          endY: gatherTarget.endPosition.y,
          endScaleX: gatherTarget.scale,
          endScaleY: gatherTarget.scale,
          delay: gatherTarget.delay ?? 0,
          endOpacity: 1,
        }
      ]
    );
    return animationParam;
  }

  /**
   * 执行多选图标落位动效
   * @param paramList 落位动效参数数组
   * @param releaseOnEnd 落位完成后是否释放落位图标
   * @param onItemEnd 单个图标落位完成回调
   * returns 落位动效是否执行完成
   */
  private async doAnimation(
    paramList: DropAnimationParam[] | DropAnimationExParam[],
    releaseOnEnd: boolean,
    onItemEnd?: (param: DropAnimationParam | DropAnimationExParam) => void
  ): Promise<boolean> {
    return new Promise((resolve, reject) => {
      MultiSelectManager.getInstance().inAnimation = true;
      dropAnimationManager.startMultiDropAnimation({
        target: this.target,
        paramList: paramList,
        onAnimationEnd: (isCancel: boolean, paramList) => {
          MultiSelectManager.getInstance().inAnimation = false;
          resolve(isCancel)
        },
        onAnimationItemEnd: (param) => {
          onItemEnd?.(param)
          log.showInfo(`${param.key} animation end`)
        },
        releaseOnEnd: releaseOnEnd
      });
    })
  }

  private cancelAnimation: cancelAnimationType = () => {
    dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.GATHER_MOVE, false);
  }

  private hideAnimationItem = (): void => {
    dropAnimationManager.hideAnimationItemByScene(this.scene);
  }

  private updateAnimationTarget: updateAnimationTargetType = (position: Position): void => {
    dropAnimationManager.updateAnimationTargetPosition(this.scene, position)
  }
}

export const multiSelectAnimateManager: MultiSelectAnimateManager =
  SingletonHelper.getInstance(MultiSelectAnimateManager, TAG);