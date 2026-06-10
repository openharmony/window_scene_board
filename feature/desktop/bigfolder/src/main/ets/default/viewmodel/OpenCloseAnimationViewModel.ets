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
import { animateExBreak, AnimateExCallback, animateExDelete, animateExToImmediately } from '@ohos/windowscene/Index';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AnimatorParameter, aniParamModel, OpenCloseAnimator } from '../model/AnimationParameterModel'

const TAG: string = 'OpenCloseAnimationViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const HEX: number = 16;

/**
 * 文件夹打开关闭动效操作方法类，包含以下功能：
 * 打断对应文件夹类型的打开关闭动效
 * 删除对应文件夹类型的打开关闭动效处理和动效结束处理
 * 开始对应文件夹类型的打开关闭动效
 * 添加对应文件夹类型的打开关闭动效结束处理和节点刷新处理
 */
export class OpenCloseAnimationViewModel {
  /**
   * 打断对应文件夹类型的打开关闭动效
   *
   * @param type 由折叠态类型或上展开态类型，用于识别具体使用哪个指定动效
   * @param isOpen ture: 打开动效, false: 关闭动效
   */
  public breakFolderAnimation(type: number, isOpen: boolean): void {
    let anis: OpenCloseAnimator[] = aniParamModel.findAnimators(type);
    if (anis.length == 0) {
      log.showWarn('not find Animator on breakOpenAnimation');
      return;
    }
    log.showInfo('breakFolderAnimation isOpen: %{public}s, type: ', isOpen, type.toString(HEX));
    let openAni: OpenCloseAnimator = anis[isOpen ? 0 : 1];
    this.breakAnimation(openAni.bottomTextParam);
    this.breakAnimation(openAni.backgroundParam);
    this.breakAnimation(openAni.iconParam);
    this.breakAnimation(openAni.titleParam);
    this.breakAnimation(openAni.iconOptParam);
  }

  /**
   * 删除对应文件夹类型的打开关闭动效处理和动效结束处理
   *
   * @param type 由折叠态类型或上展开态类型，用于识别具体使用哪个指定动效
   * @param isOpen ture: 打开动效, false: 关闭动效
   */
  public deleteFolderAnimation(type: number, isOpen: boolean): void {
    let anis: OpenCloseAnimator[] = aniParamModel.findAnimators(type);
    if (anis.length == 0) {
      log.showWarn('not find Animator on deleteFolderAnimation');
      return;
    }
    log.showInfo('deleteFolderAnimation isOpen: %{public}s, type: %{public}s', isOpen, type.toString(HEX));
    let openAni: OpenCloseAnimator = anis[isOpen ? 0 : 1];
    this.deleteAnimation(openAni.bottomTextParam);
    this.deleteAnimation(openAni.backgroundParam);
    this.deleteAnimation(openAni.iconParam);
    this.deleteAnimation(openAni.titleParam);
    this.deleteAnimation(openAni.iconOptParam);
  }

  /**
   * 向对应文件夹类型的打开关闭动效中添加展开态图标底部文字动效处理
   *
   * @param type 由折叠态类型或上展开态类型，用于识别具体使用哪个指定动效
   * @param isOpen ture: 打开动效, false: 关闭动效
   * @param callback 动效节点处理
   * @param index 指定某个秩序感批次，默认为首批次动效
   */
  public addBottomTextEvent(type: number, isOpen: boolean, callback: AnimateExCallback, index: number = 0): void {
    let anis: OpenCloseAnimator[] = aniParamModel.findAnimators(type);
    if (anis.length == 0) {
      log.showWarn('not find Animator on addBottomTextEvent');
      return;
    }
    let openAni: OpenCloseAnimator = anis[isOpen ? 0 : 1];
    this.addEvent(openAni.bottomTextParam, callback, index, 'BottomText');
  }

  /**
   * 向对应文件夹类型的打开关闭动效中添加背板动效处理
   *
   * @param type 由折叠态类型或上展开态类型，用于识别具体使用哪个指定动效
   * @param isOpen ture: 打开动效, false: 关闭动效
   * @param callback 动效节点处理
   * @param index 指定某个秩序感批次，默认为首批次动效
   */
  public addBgEvent(type: number, isOpen: boolean, callback: AnimateExCallback, index: number = 0): void {
    let anis: OpenCloseAnimator[] = aniParamModel.findAnimators(type);
    if (anis.length == 0) {
      log.showWarn('not find Animator on addBgEvent');
      return;
    }
    let openAni: OpenCloseAnimator = anis[isOpen ? 0 : 1];
    this.addEvent(openAni.backgroundParam, callback, index, 'Background');
  }

  /**
   * 向对应文件夹类型的打开关闭动效中添加展开态图标动效处理
   *
   * @param type 由折叠态类型或上展开态类型，用于识别具体使用哪个指定动效
   * @param isOpen ture: 打开动效, false: 关闭动效
   * @param callback 动效节点处理
   * @param index 指定某个秩序感批次，默认为首批次动效
   */
  public addIconEvent(type: number, isOpen: boolean, callback: AnimateExCallback, index: number = 0): void {
    let anis: OpenCloseAnimator[] = aniParamModel.findAnimators(type);
    if (anis.length == 0) {
      log.showWarn('not find Animator on addIconEvent');
      return;
    }
    let openAni: OpenCloseAnimator = anis[isOpen ? 0 : 1];
    this.addEvent(openAni.iconParam, callback, index, 'Icon');
  }

  /**
   * 向对应文件夹类型的打开关闭动效中添加展开态图标透明度动效处理
   *
   * @param type 由折叠态类型或上展开态类型，用于识别具体使用哪个指定动效
   * @param isOpen ture: 打开动效, false: 关闭动效
   * @param callback 动效节点处理
   * @param index 指定某个秩序感批次，默认为首批次动效
   */
  public addIconOptEvent(type: number, isOpen: boolean, callback: AnimateExCallback, index: number = 0): void {
    let anis: OpenCloseAnimator[] = aniParamModel.findAnimators(type);
    if (anis.length == 0) {
      log.showWarn('not find Animator on addIconEvent');
      return;
    }
    let openAni: OpenCloseAnimator = anis[isOpen ? 0 : 1];
    this.addEvent(openAni.iconOptParam, callback, index, 'IconOpt');
  }

  /**
   * 向对应文件夹类型的打开关闭动效中添加展开态文件夹标题动效处理
   *
   * @param type 由折叠态类型或上展开态类型，用于识别具体使用哪个指定动效
   * @param isOpen ture: 打开动效, false: 关闭动效
   * @param callback 动效节点处理
   * @param index 指定某个秩序感批次，默认为首批次动效
   */
  public addTitleEvent(type: number, isOpen: boolean, callback: AnimateExCallback, index: number = 0): void {
    let anis: OpenCloseAnimator[] = aniParamModel.findAnimators(type);
    if (anis.length == 0) {
      log.showWarn('not find Animator on addTitleEvent');
      return;
    }
    let openAni: OpenCloseAnimator = anis[isOpen ? 0 : 1];
    this.addEvent(openAni.titleParam, callback, index, 'Title');
  }

  /**
   * 向对应文件夹类型的打开关闭动效中添加展开态图标底部文字动效结束回调
   *
   * @param type 由折叠态类型或上展开态类型，用于识别具体使用哪个指定动效
   * @param isOpen ture: 打开动效, false: 关闭动效
   * @param callback 动效结束回调
   * @param index 指定某个秩序感批次，默认为首批次动效
   */
  public addBottomTextFinish(type: number, isOpen: boolean, callback: AnimateExCallback, index: number = 0): void {
    let anis: OpenCloseAnimator[] = aniParamModel.findAnimators(type);
    if (anis.length == 0) {
      log.showWarn('not find Animator on addBottomTextFinish');
      return;
    }
    let openAni: OpenCloseAnimator = anis[isOpen ? 0 : 1];
    this.addFinish(openAni.bottomTextParam, callback, index, 'BottomText');
  }

  /**
   * 向对应文件夹类型的打开关闭动效中添加展开态背板动效结束回调
   *
   * @param type 由折叠态类型或上展开态类型，用于识别具体使用哪个指定动效
   * @param isOpen ture: 打开动效, false: 关闭动效
   * @param callback 动效结束回调
   * @param index 指定某个秩序感批次，默认为首批次动效
   */
  public addBgFinish(type: number, isOpen: boolean, callback: AnimateExCallback, index: number = 0): void {
    let anis: OpenCloseAnimator[] = aniParamModel.findAnimators(type);
    if (anis.length == 0) {
      log.showWarn('not find Animator on addBgFinish');
      return;
    }
    let openAni: OpenCloseAnimator = anis[isOpen ? 0 : 1];
    this.addFinish(openAni.backgroundParam, callback, index, 'Background');
  }

  /**
   * 向对应文件夹类型的打开关闭动效中添加展开态图标动效结束回调
   *
   * @param type 由折叠态类型或上展开态类型，用于识别具体使用哪个指定动效
   * @param isOpen ture: 打开动效, false: 关闭动效
   * @param callback 动效结束回调
   * @param index 指定某个秩序感批次，默认为首批次动效
   */
  public addIconFinish(type: number, isOpen: boolean, callback: AnimateExCallback, index: number = 0): void {
    let anis: OpenCloseAnimator[] = aniParamModel.findAnimators(type);
    if (anis.length == 0) {
      log.showWarn('not find Animator on addIconFinish');
      return;
    }
    let openAni: OpenCloseAnimator = anis[isOpen ? 0 : 1];
    this.addFinish(openAni.iconParam, callback, index, 'Icon');
  }

  /**
   * 向对应文件夹类型的打开关闭动效中添加展开态图标透明度动效结束回调
   *
   * @param type 由折叠态类型或上展开态类型，用于识别具体使用哪个指定动效
   * @param isOpen ture: 打开动效, false: 关闭动效
   * @param callback 动效结束回调
   * @param index 指定某个秩序感批次，默认为首批次动效
   */
  public addIconOptFinish(type: number, isOpen: boolean, callback: AnimateExCallback, index: number = 0): void {
    let anis: OpenCloseAnimator[] = aniParamModel.findAnimators(type);
    if (anis.length == 0) {
      log.showWarn('not find Animator on addIconFinish');
      return;
    }
    let openAni: OpenCloseAnimator = anis[isOpen ? 0 : 1];
    this.addFinish(openAni.iconOptParam, callback, index, 'IconOpt');
  }

  /**
   * 向对应文件夹类型的打开关闭动效中添加展开态文件夹标题动效结束回调
   *
   * @param type 由折叠态类型或上展开态类型，用于识别具体使用哪个指定动效
   * @param isOpen ture: 打开动效, false: 关闭动效
   * @param callback 动效结束回调
   * @param index 指定某个秩序感批次，默认为首批次动效
   */
  public addTitleFinish(type: number, isOpen: boolean, callback: AnimateExCallback, index: number = 0): void {
    let anis: OpenCloseAnimator[] = aniParamModel.findAnimators(type);
    if (anis.length == 0) {
      log.showWarn('not find Animator on addTitleFinish');
      return;
    }
    let openAni: OpenCloseAnimator = anis[isOpen ? 0 : 1];
    this.addFinish(openAni.titleParam, callback, index, 'Title');
  }

  /**
   * 开始对应文件夹类型的打开关闭动效，如动效集合中无动效节点刷新则不开启对应动效
   *
   * @param type 由折叠态类型或上展开态类型，用于识别具体使用哪个指定动效
   * @param isOpen ture: 打开动效, false: 关闭动效
   */
  public startFolderAnimation(type: number, isOpen: boolean, isBackgroundLast: boolean = false): void {
    let anis: OpenCloseAnimator[] = aniParamModel.findAnimators(type);
    if (anis.length == 0) {
      log.showWarn('not find Animator on startFolderAnimation');
      return;
    }
    let openAni: OpenCloseAnimator = anis[isOpen ? 0 : 1];
    if (!isBackgroundLast) {
      // 保持性能基线, 需要让背板和以前效果一致
      this.startAnimation(openAni.backgroundParam);
    }
    this.startAnimation(openAni.bottomTextParam);
    this.startAnimation(openAni.titleParam);
    this.startAnimation(openAni.iconParam);
    this.startAnimation(openAni.iconOptParam);
    if (isBackgroundLast) {
      // 背板最后启动, 图标过多, 启动费时误差可能导致背板视觉上移动过快
      this.startAnimation(openAni.backgroundParam);
    }
  }

  private breakAnimation(animatorParameter: AnimatorParameter | undefined): void {
    if (animatorParameter) {
      animatorParameter.animatorNames.forEach(name => {
        animateExBreak(name, 'break by close or open');
      });
    }
  }

  private deleteAnimation(animatorParameter: AnimatorParameter | undefined): void {
    if (animatorParameter) {
      animatorParameter.animatorNames.forEach(name => {
        animateExDelete(name);
        let index: number = animatorParameter.animatorNames.indexOf(name);
        animatorParameter.eventArray[index] = [];
        animatorParameter.finishArray[index] = [];
      });
    }
  }

  private addEvent(animatorParameter: AnimatorParameter | undefined,
    callback: AnimateExCallback, index: number, msg: string): void {
    if (!animatorParameter) {
      log.showWarn('animatorParameter is Inactive on addEvent, %{public}s', msg);
      return;
    }
    if (animatorParameter.animatorNames.length <= index) {
      log.showWarn('No valid index on addEvent, index: %{public}d, %{public}s', index, msg);
      return;
    }
    animatorParameter.eventArray[index].push(callback);
  }

  private addFinish(animatorParameter: AnimatorParameter | undefined,
    callback: AnimateExCallback, index: number, msg: string): void {
    if (!animatorParameter) {
      log.showWarn('animatorParameter is Inactive on addFinish, %{public}s', msg);
      return;
    }
    if (animatorParameter.animatorNames.length <= index) {
      log.showWarn('No valid index on addFinish, index: %{public}d, %{public}s', index, msg);
      return;
    }
    animatorParameter.finishArray[index].push(callback);
  }

  private startAnimation(animatorParameter: AnimatorParameter | undefined): void {
    if (!animatorParameter) {
      return;
    }
    animatorParameter.animatorNames.forEach(name => {
      let index: number = animatorParameter.animatorNames.indexOf(name);
      if (animatorParameter.eventArray[index].length == 0) {
        // 当未设置节点变化时则不发起动效
        log.showWarn('%{public}s has not event', name);
        return;
      }
      animateExToImmediately(
        name,
        animatorParameter.params[index],
        () => {
          animatorParameter.eventArray[index].forEach(callback => {
            callback();
          });
          // 执行完成后, 立即清空
          animatorParameter.eventArray[index] = [];
        },
        () => {
          animatorParameter.finishArray[index].forEach(callback => {
            callback();
          });
          // 执行完成后, 立即清空
          animatorParameter.finishArray[index] = [];
        });
    });
  }
}
