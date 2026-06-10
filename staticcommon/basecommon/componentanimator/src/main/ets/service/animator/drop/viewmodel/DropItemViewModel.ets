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
import image from '@ohos.multimedia.image';
import { dragSnapshotHelper, SnapshotListener, SnapshotType } from '@ohos/componenthelper';
import {
  animationResult,
  DropAnimationExEvent,
  DropAnimationExParam,
  DropAnimationParam
} from '../bean/DropAnimationParam';
import { DropAnimationCancelReason, DropAnimationConfig, DropAnimationDestination } from
  '../config/DropAnimationConfig';
import { AnimationViewData } from '../../common/viewmodel/AnimationViewData';
import curves from '@ohos.curves';
import { AnimateParam } from 'AnimateToParam';
import { CustomAnimation, CustomAnimationParam,
  CustomAnimationUpdateParam } from '../../common/utils/FrameAnimationUtil';
import { FrameAnimationParam, FrameAnimationUpdateParam } from '../bean/FrameAnimationParam';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { DragConstants } from '@ohos/commonconstants'

const TAG: string = 'DropItemViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 落位元素的属性管理类
 */
export class DropItemViewModel {
  private dropItemViewData: AnimationViewData;
  private asyncDropAnimationResolve?: (animationResult: animationResult) => void
  private target: DropAnimationDestination = 0;
  private snapshotListener?: SnapshotListener;
  private dropSnapshot?: image.PixelMap;
  private frameAnimation: CustomAnimation = new CustomAnimation();

  /**
   * 构造函数
   *
   * @param dropItemViewData 落位元素的属性
   */
  public constructor(dropItemViewData: AnimationViewData) {
    this.dropItemViewData = dropItemViewData;
  }

  /**
   * 设置落位元素的初始宽度
   *
   * @param width 落位元素的宽度
   * @returns 落位动效管理类实例
   */
  public setWidth(width: number): DropItemViewModel {
    this.dropItemViewData.width = width;
    return this;
  }

  /**
   * 设置落位元素的初始高度
   *
   * @param height 落位元素的高度
   * @returns 落位动效管理类实例
   */
  public setHeight(height: number): DropItemViewModel {
    this.dropItemViewData.height = height;
    return this;
  }

  /**
   * 设置落位元素的ImageFit
   *
   * @param imageFit 落位元素的imageFit
   * @returns 落位动效管理类实例
   */
  public setImageFit(imageFit: number): DropItemViewModel {
    this.dropItemViewData.imageFit = imageFit;
    return this;
  }

  /**
   * 设置落位元素的初始圆角
   *
   * @param radius 落位元素的圆角
   * @returns 落位动效管理类实例
   */
  public setRadius(radius: number): DropItemViewModel {
    this.dropItemViewData.radius = radius;
    return this;
  }

  /**
   * 设置落位元素的初始比例
   *
   * @param scale 落位元素的比例
   * @returns 落位动效管理类实例
   */
  public setScale(scaleX: number, scaleY?: number): DropItemViewModel {
    this.dropItemViewData.scaleX = scaleX;
    this.dropItemViewData.scaleY = (scaleY ?? scaleX);
    return this;
  }

  /**
   * 设置落位元素初始偏移量
   *
   * @param x x方向偏移量
   * @param y y方向偏移量
   * @returns 落位动效管理类实例
   */
  public setOffset(x: number, y: number): DropItemViewModel {
    this.dropItemViewData.offsetX = x;
    this.dropItemViewData.offsetY = y;
    return this;
  }

  /**
   * 设置落位元素松手起始偏移量
   *
   * @param x x方向偏移量
   * @param y y方向偏移量
   * @returns 落位动效管理类实例
   */
  public setStartOffset(x: number, y: number): DropItemViewModel {
    this.dropItemViewData.startOffsetX = x;
    this.dropItemViewData.startOffsetY = y;
    return this;
  }

  /**
   * 设置落位元素的结束比例
   *
   * @param scale 落位元素的比例
   * @returns 落位动效管理类实例
   */
  public setEndScale(scaleX: number, scaleY?: number): DropItemViewModel {
    this.dropItemViewData.endScaleX = scaleX;
    this.dropItemViewData.endScaleY = (scaleY ?? scaleX);
    return this;
  }

  /**
   * 设置落位元素初始旋转量
   *
   * @param rotate 旋转量
   * @returns 落位动效管理类实例
   */
  public setRotate(rotate: RotateOptions): DropItemViewModel {
    this.dropItemViewData.rotate = rotate;
    return this;
  }

  /**
   * 设置落位元素的不透明度
   * @param opacity 不透明度
   * @returns 落位动效管理类实例
   */
  public setOpacity(opacity: number): DropItemViewModel {
    this.dropItemViewData.opacity = opacity;
    return this;
  }

  /**
   * 设置落位元素的zIndex
   * @param opacity 不透明度
   * @returns 落位动效管理类实例
   */
  public setZIndex(zIndex: number): DropItemViewModel {
    this.dropItemViewData.zIndex = zIndex;
    return this;
  }

  /**
   * 设置落位元素是否有模糊效果
   *
   * @param useEffect 落位元素是否有模糊效果
   * @returns 落位动效管理类实例
   */
  public setUseEffect(useEffect: boolean): DropItemViewModel {
    this.dropItemViewData.useEffect = useEffect;
    return this;
  }

  /**
   * 设置落位元素的截图，不直接设置给dropItemViewData，统一在loadSnapshot方法中加载该截图，使落位元素组件上树
   *
   * @param pixmap 落位元素的截图
   * @returns 落位动效管理类实例
   */
  public setDropSnapshot(pixmap?: image.PixelMap): DropItemViewModel {
    this.dropSnapshot = pixmap;
    return this;
  }

  /**
   * 获取落位元素的截图
   *
   * @returns 获取落位元素的截图
   */
  private getDropItemSnapshot(): image.PixelMap | undefined {
    return dragSnapshotHelper.getSnapshot(SnapshotType.DROP, this.dropItemViewData.key);
  }

  /**
   * 加载落位元素截图到viewData中，使落位元素开始创建
   */
  public loadSnapshot(): void {
    if (this.dropItemViewData.pixmap != null || this.snapshotListener != null) {
      return;
    }
    log.showInfo('syncData, viewData:%{public}s', this.dropItemViewData.toString());
    if (this.dropSnapshot != null) {
      this.dropItemViewData.pixmap = this.dropSnapshot;
      this.dropSnapshot = undefined;
      return;
    }
    this.dropItemViewData.pixmap = this.getDropItemSnapshot();
    if (this.dropItemViewData.pixmap == null) {
      this.snapshotListener = {
        onSnapshotFinish: (image: image.PixelMap, type: SnapshotType, key: string) => {
          if (this.dropItemViewData.key === key && (type === SnapshotType.DROP || type === SnapshotType.BOTH)) {
            log.showInfo(`onSnapshotFinish key:${key} type:${type}`);
            this.dropItemViewData.pixmap = image;
            dragSnapshotHelper.unregisterSnapshotListener(this.snapshotListener, this.dropItemViewData.key);
          }
        }
      }
      dragSnapshotHelper.registerSnapshotListener(this.snapshotListener, this.dropItemViewData.key);
    }
  }

  /**
   * 对外提供落位截图接口
   * @returns 获取落位元素的截图
   */
  public getDropSnapshot(): image.PixelMap | undefined {
    return this.dropItemViewData.pixmap;
  }

  /**
   * 开始执行落位动效
   *
   * @param param 落位动效参数
   * @returns 是否成功启动落位动效
   */
  public startAnimation(param: DropAnimationParam, target: DropAnimationDestination, delay: number,
    onDropAnimationEnd?: (isCancel: boolean) => void): boolean {
    if (this.illegalsAnimate()) {
      return false;
    }
    this.startAnimationAsync(param, target, true, delay).then((res: animationResult) => {
      onDropAnimationEnd?.(res === animationResult.CANCEL)
    })
    return true;
  }

  /**
   * 更新dropItemViewData
   * @param param 落位动效参数
   * @param scaleFactor 落位动效尺寸
   */
  public updateDropItemViewData(
    param: DropAnimationParam | DropAnimationExParam,
    scaleFactor: DropAnimationDestination
  ): void {
    this.dropItemViewData.translateX = param.startX;
    this.dropItemViewData.translateY = param.startY;
    this.dropItemViewData.isShow = true;
    if (this.dropItemViewData.pixmap?.getPixelBytesNumber() === undefined) {
      this.dropItemViewData.pixmap = this.getDropItemSnapshot();
    }
    this.dropItemViewData.translateX += this.dropItemViewData.startOffsetX;
    this.dropItemViewData.translateY += this.dropItemViewData.startOffsetY;
    if (param instanceof DropAnimationParam) {
      if (param.startWidth !== 0 && param.startHeight !== 0) {
        log.showInfo(`onDragDrop actual width:${param.startWidth} height:${param.startHeight}`)
        this.dropItemViewData.scaleX = param.startWidth / this.dropItemViewData.width;
        this.dropItemViewData.scaleY = param.startHeight / this.dropItemViewData.height;
        return;
      }
    }
    this.dropItemViewData.scaleX *= scaleFactor;
    this.dropItemViewData.scaleY *= scaleFactor;
  }

  public startAnimationAsync(
    param: DropAnimationParam | DropAnimationExParam,
    target: DropAnimationDestination,
    releaseOnEnd: boolean = true,
    delay: number,
  ): Promise<animationResult> {
    return new Promise((resolve, reject) => {
      if (this.illegalsAnimate()) {
        resolve(animationResult.NOT_START);
        return;
      }
      const scaleFactor = DropAnimationConfig.getScaleFactorByScene(DropAnimationConfig.getDropAnimationScene(target));
      log.showInfo('startDropAnimation target:%{public}d delay:%{public}d param:%{public}s scaleFactor:%{public}d',
        target, delay, param.toString(), scaleFactor);
      this.target = target;
      this.updateDropItemViewData(param, scaleFactor);
      this.asyncDropAnimationResolve = resolve;

      if (param instanceof DropAnimationParam) {
        this.processDropAnimationParam(param as DropAnimationParam);
        animateTo({
          delay: (param as DropAnimationParam).delay ?? delay,
          curve: param.curve,
          duration: param.duration,
          onFinish: () => {
            this.onAnimationFinish(false, releaseOnEnd);
          },
        }, () => {
          param.parallelAnimation?.();
          this.applyAnimationChangeToViewData(param as DropAnimationExEvent);
        });
      } else if (param instanceof DropAnimationExParam) {
        this.dropToFolderAnimationAsync(param as DropAnimationExParam, releaseOnEnd);
      }
    })
  }

  private dropToFolderAnimationAsync(param: DropAnimationExParam, releaseOnEnd: boolean) {
    Promise.all(param.eventList.map((event: DropAnimationExEvent, index: number) => {
      return new Promise((resolve: (isCancel: boolean, releaseOnEnd: boolean) => void) => {
        const animateParam: AnimateParam = {
          curve: event.curve ?? param.curve,
          duration: event.duration,
          delay: event.delay,
          onFinish: () => resolve(false, releaseOnEnd)
        };
        animateTo(animateParam, () => {
          this.applyAnimationChangeToViewData(event)
        });
      });
    })).then(() => this.onAnimationFinish(false, releaseOnEnd));
  }

  private getSkeletonKey(key: string, index: number) {
    return `${key}_${index}`;
  }

  /**
   * animate对象参数赋值
   */
  private applyAnimationChangeToViewData(event: DropAnimationExEvent): void {
    this.dropItemViewData.opacity = event.endOpacity ?? this.dropItemViewData.opacity;
    this.dropItemViewData.translateX = event.endX ?? this.dropItemViewData.translateX;
    this.dropItemViewData.translateY = event.endY ?? this.dropItemViewData.translateY;
    this.dropItemViewData.width = event.endWidth ?? this.dropItemViewData.width;
    this.dropItemViewData.height = event.endHeight ?? this.dropItemViewData.height;
    this.dropItemViewData.radius = event.endRadius ?? this.dropItemViewData.radius;
    this.dropItemViewData.scaleX = event.endScaleX ?? this.dropItemViewData.scaleX;
    this.dropItemViewData.scaleY = event.endScaleY ?? this.dropItemViewData.scaleY;
    this.dropItemViewData.rotate = event.endRotate ?? this.dropItemViewData.rotate;
  }

  /**
   * 开启帧动效 和animateTo不兼容， 不能同时启用
   * @param target
   * @param params
   * @param releaseOnEnd
   * @returns
   */
  public startFrameAnimation(
    target: DropAnimationDestination,
    params: FrameAnimationParam[],
    releaseOnEnd: boolean = true
  ): Promise<animationResult> | undefined {
    if (this.illegalsAnimate()) {
      return undefined;
    }
    log.showInfo(`startFrameAnimation ${params[0].id} ${params.map(item => {
      return `animateId: ${item.animationId} begin: ${item.begins.toString()} target: ${item.targets.toString()}`
    }).toString()}`);
    this.target = target;
    animateTo({duration: 0}, () => {
      this.dropItemViewData.isShow = true;
    })
    params.map((param: FrameAnimationParam) => {
      this.frameAnimation.setAnimationItem({
        id: param.animationId,
        delay: param.delay,
        duration: param.duration,
        endDelay: param.endDelay,
        curves: param.curves,
        begins: param.begins,
        targets: param.targets,
        onRender: (progress: number[]) => {
          param.onRender(this.dropItemViewData, progress);
        },
        onFinish: (): void => {}
      });
    });
    return new Promise((resolve) => {
      this.asyncDropAnimationResolve = resolve;
      this.frameAnimation.doAnimation().then((isCancel: boolean) => {
        log.showInfo(`startFrameAnimation doAnimation ${isCancel}`);
        if (this.asyncDropAnimationResolve === resolve) {
          this.onAnimationFinish(isCancel, releaseOnEnd);
        }
      });
    });
  }

  public updateFrameAnimation(updateParams: FrameAnimationUpdateParam[]): boolean {
    if (this.illegalsAnimate() || this.frameAnimation.isEmpty) {
      return false;
    }
    this.frameAnimation.updateAnimation(
      updateParams.map((param: FrameAnimationUpdateParam): CustomAnimationUpdateParam => {
        return {
          id: param.animationId,
          delay: param.delay,
          duration: param.duration,
          curves: param.curves,
          targets: param.targets,
        }
      })
    );
    return true;
  }

  private illegalsAnimate(): boolean {
    if (this.dropItemViewData.pixmap == null) {
      log.showWarn('cannot start drop animation without snapshot');
      return true;
    }
    return false;
  }

  private processDropAnimationParam(param: DropAnimationParam): void {
    if (param.endWidth === 0) {
      param.endWidth = this.dropItemViewData.width;
    }
    if (param.endHeight === 0) {
      param.endHeight = this.dropItemViewData.height;
    }
    if (param.endRadius === 0) {
      param.endRadius = this.dropItemViewData.radius;
    }
    if (param.endScaleX === 0) {
      param.endScaleX = this.dropItemViewData.endScaleX;
    }
    if (param.endScaleY === 0) {
      param.endScaleY = this.dropItemViewData.endScaleY;
    }
  }

  private onAnimationFinish(isCancel: boolean, releaseOnEnd: boolean = true, count: number = 0): void {
    if (!this.isInAnimation()) {
      return;
    }
    log.showInfo(`onAnimationFinish isCancel:${isCancel} release: ${releaseOnEnd}`);
    if (releaseOnEnd) {
      this.clearDropData();
    }
    this.asyncDropAnimationResolve?.(isCancel ? animationResult.CANCEL : animationResult.FINISH);
    this.asyncDropAnimationResolve = undefined;
    this.target = 0;
    dragSnapshotHelper.unregisterSnapshotListener(this.snapshotListener, this.dropItemViewData.key);
  }

  public clearDropData(): void {
    log.showInfo(`clearDropData key:${this.dropItemViewData.key}`);
    this.dropItemViewData.isShow = false;
    this.dropItemViewData.pixmap = undefined;
  }

  /**
   * 取消落位动效
   *
   * @param reason 落位动效取消的原因
   */
  public cancelAnimation(reason: DropAnimationCancelReason, release: boolean = true): void {
    if (DropAnimationConfig.canCancel(this.target, reason)) {
      log.showInfo(`animation is canceled. key:${this.dropItemViewData.key} target:${this.target} reason:${reason} ` +
        `release:${release}`);
      this.frameAnimation.clear();
      this.onAnimationFinish(true, release);
    }
  }

  /**
   * 是否在落位动效过程中
   *
   * @returns 是否在落位动效过程中
   */
  public isInAnimation(): boolean {
    return this.dropItemViewData.isShow;
  }
}