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

import { CommonUtils } from '@ohos/basicutils';
import { ImmersiveAnimScene, ImmersiveNtfScene } from '../../common/anim/ImmersiveAnimConstants';
import { CapsulePositionType } from '../../common/ImmersiveConstants';
import { ImmersiveCapsuleList } from './ImmersiveCapsuleList';
import { ImmersiveDataGroupPacker } from './ImmersiveDataGroupProcessor';
import { ImmersiveNtfData } from './ImmersiveNtfData';
import { immersiveNtfSceneHelper } from './ImmersiveNtfSceneHelper';
import { ImmersiveCapsuleConstants as CapConst } from '../../common/constants/ImmersiveCapsuleConstants';

/**
 * 胶囊场景检测辅助类
 */
export class ImmersiveCapsuleSceneHelper {
  /**
   * 胶囊当前显示数据列表
   */
  private curList?: ImmersiveCapsuleList;

  /**
   * 胶囊上次显示数据列表
   */
  private oldList?: ImmersiveCapsuleList;

  /**
   * 沉浸锁屏分组通知数据集
   */
  private groupManager?: ImmersiveDataGroupPacker;

  /**
   * 构造函数
   *
   * @param oldList 上次显示数据列表
   * @param curList 当前显示数据列表
   * @param groupManager 分组通知数据集
   */
  constructor(oldList: ImmersiveCapsuleList, curList: ImmersiveCapsuleList, groupManager: ImmersiveDataGroupPacker) {
    this.oldList = oldList;
    this.curList = curList;
    this.groupManager = groupManager;
  }

  /**
   * 检测胶囊动效场景
   *
   * @returns 胶囊动效场景
   */
  checkAnimScene(): ImmersiveAnimScene | undefined {
    let oldGroupSize = this.groupManager?.getOldGroupSize() ?? 0;
    let newGroupSize = this.groupManager?.getGroupSize() ?? 0;
    if (oldGroupSize === 0 && newGroupSize > 0) {
      // 胶囊从无到有
      return ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW;
    } else if (oldGroupSize > 0 && newGroupSize === 0) {
      // 胶囊从有到无
      return ImmersiveAnimScene.SCENE_CAPSULE_ROOT_HIDE;
    } else if (oldGroupSize !== newGroupSize) {
      return this.checkAddOrRemoveScene(oldGroupSize, newGroupSize);
    } else if (newGroupSize !== 0 && newGroupSize === oldGroupSize && this.isSingleTopRemindUpdate()) {
      return ImmersiveAnimScene.SCENE_CAPSULE_TOP_UPDATE;
    } else if (newGroupSize !== 0 && newGroupSize === oldGroupSize && this.isSingleNotTopRemindUpdate()) {
      return ImmersiveAnimScene.SCENE_CAPSULE_REMIND;
    }
    return undefined;
  }

  private checkAddOrRemoveScene(oldSize: number, newSize: number): ImmersiveAnimScene | undefined {
    if (newSize > oldSize) {
      // 1条或多条新增到多条
      if (this.isTopCapsuleChange()) {
        return ImmersiveAnimScene.SCENE_CAPSULE_STACK_SHOW;
      } else if (this.isSameTopCapsule()) {
        return ImmersiveAnimScene.SCENE_CAPSULE_REMIND;
      }
    } else if (newSize < oldSize) {
      // 多条减少到1条或多条
      if (this.isTopCapsuleChange()) {
        return ImmersiveAnimScene.SCENE_CAPSULE_STACK_REMOVE;
      } else if (newSize === 1 && this.isSameTopCapsule()) {
        return ImmersiveAnimScene.SCENE_CAPSULE_SHADOW_REMOVE;
      }
    }
    return undefined;
  }

  /**
   * 判断顶部胶囊是否变更
   *
   * @returns 顶部胶囊是否变更
   */
  private isTopCapsuleChange(): boolean {
    let oldContent = this.oldList?.getNtfData(CapsulePositionType.TYPE_CONTENT);
    let newContent = this.curList?.getNtfData(CapsulePositionType.TYPE_CONTENT);
    return oldContent?.groupKey !== newContent?.groupKey;
  }

  /**
   * 判断顶部胶囊是否未变更
   *
   * @returns 顶部胶囊是否未变更
   */
  private isSameTopCapsule(): boolean {
    let oldContent = this.oldList?.getNtfData(CapsulePositionType.TYPE_CONTENT);
    let newContent = this.curList?.getNtfData(CapsulePositionType.TYPE_CONTENT);
    return oldContent?.groupKey === newContent?.groupKey;
  }

  /**
   * 判断顶部胶囊是否是单条更新场景
   *
   * @returns 顶部胶囊是否是单条更新场景
   */
  private isSingleTopUpdate(): boolean {
    let oldContent = this.oldList?.getNtfData(CapsulePositionType.TYPE_CONTENT) as ImmersiveNtfData;
    let newContent = this.curList?.getNtfData(CapsulePositionType.TYPE_CONTENT) as ImmersiveNtfData;
    if (CommonUtils.isInvalid(oldContent) || CommonUtils.isInvalid(newContent)) {
      return false;
    }
    if (oldContent.groupKey !== newContent.groupKey) {
      return false;
    }
    if (!immersiveNtfSceneHelper.checkImmersiveDataScene(newContent.groupKey, ImmersiveNtfScene.SCENE_NTF_UPDATE)) {
      return false;
    }
    return (newContent.capsuleData?.isLiveCapsule() &&
      !(newContent.capsuleData?.isProgressType() || newContent.capsuleData?.isMediaPlay())) ?? false;
  }

  /**
   * 判断胶囊是否是非顶部强提醒更新场景
   *
   * @returns 胶囊是否是强提醒更新场景
   */
  private isSingleNotTopRemindUpdate(): boolean {
    let newContent = this.curList?.getNtfData(CapsulePositionType.TYPE_CONTENT) as ImmersiveNtfData;
    if (CommonUtils.isInvalid(newContent)) {
      return false;
    }
    if (immersiveNtfSceneHelper.checkImmersiveDataScene(newContent.groupKey, ImmersiveNtfScene.SCENE_NTF_UPDATE)) {
      return false;
    }
    let sceneKey: string = immersiveNtfSceneHelper.getImmersiveSceneKey();
    if (!sceneKey) {
      return false;
    }
    if (!immersiveNtfSceneHelper.checkImmersiveDataScene(sceneKey, ImmersiveNtfScene.SCENE_NTF_UPDATE)) {
      return false;
    }
    if (this.groupManager?.findGroupData(sceneKey)?.isShownInCard()) {
      // 处于沉浸态显示的实况通知没有胶囊， 不需要做更新动效
      return false;
    }
    if (this.groupManager?.findGroupData(sceneKey)?.capsuleData?.isCapsuleRemind()) {
      return true;
    }
    return false;
  }

  /**
   * 判断胶囊是否是顶部强提醒更新场景
   *
   * @returns 胶囊是否是强提醒更新场景
   */
  private isSingleTopRemindUpdate(): boolean {
    let newContent = this.curList?.getNtfData(CapsulePositionType.TYPE_CONTENT) as ImmersiveNtfData;
    if (CommonUtils.isInvalid(newContent)) {
      return false;
    }
    if (!immersiveNtfSceneHelper.checkImmersiveDataScene(newContent.groupKey, ImmersiveNtfScene.SCENE_NTF_UPDATE)) {
      return false;
    }
    if (newContent.capsuleData?.isCapsuleRemind()) {
      return true;
    }
    return false;
  }
}