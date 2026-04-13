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
import type image from '@ohos.multimedia.image';
import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants} from '@ohos/commonconstants';
import { IndicatorType, LineType, LiveIconName, LiveType } from '../../common/LiveConstants';
import { LiveButtonArray } from '../extend/LiveButtonData';
import { OtherBaseTemplate } from './OtherBaseTemplate';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'LiveProgressTemplate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 实况卡片模板，扩展区进度类模板
 */
@Observed
export class LiveProgressTemplate extends OtherBaseTemplate {
  /**
   * 当前进度
   */
  progress?: number = 0;

  /**
   * 进度条颜色,默认为蓝色#FF317AF7
   */
  color?: string = '#FF317AF7';

  /**
   * 进度条背景颜色
   */
  backgroundColor?: string;

  /**
   * 扩展区指示器小图标显示类型
   */
  indicatorType?: number = IndicatorType.NOT_SHOW;

  /**
   * 扩展区指示器小图标
   */
  indicatorIcon?: image.PixelMap;

  /**
   * 扩展区指示器小图标资源路径
   */
  indicatorIconRes?: string;

  /**
   * 扩展区进度条显示类型
   */
  lineType?: number = LineType.DOTTED_PROGRESS;

  /**
   * 节点图标列表，值图片
   */
  nodeIcons?: LiveButtonArray;

  /**
   * 节点图标资源列表，值为本地资源路径
   */
  nodeIconsRes?: Array<string>;

  /**
   * 复写接口ILiveTemplateData
   *
   * @returns 实况类型
   */
  getLiveType(): LiveType {
    return LiveType.PROGRESS;
  }

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    super.update(other, forceRefresh);
    if (!(other instanceof LiveProgressTemplate)) {
      return;
    }
    let otherTemplate = other as LiveProgressTemplate;
    this.setProgress(otherTemplate.progress, forceRefresh);
    this.setColor(otherTemplate.color, forceRefresh);
    this.setBackgroundColor(otherTemplate.backgroundColor, forceRefresh);
    this.setIndicatorType(otherTemplate.indicatorType, forceRefresh);
    this.setIndicatorIcon(otherTemplate.indicatorIcon, forceRefresh || otherTemplate.clearImgForUpdate[LiveIconName.INDICATOR_ICON_NAME]);
    this.setIndicatorIconRes(otherTemplate.indicatorIconRes, forceRefresh);
    this.setLineType(otherTemplate.lineType, forceRefresh);
    if (forceRefresh || CommonUtils.isInvalid(this.nodeIcons)) {
      this.nodeIcons = otherTemplate.nodeIcons;
    } else {
      this.nodeIcons.update(otherTemplate.nodeIcons, forceRefresh);
    }

    this.setNodeIconsRes(otherTemplate.nodeIconsRes, forceRefresh);
  }

  /**
   * 设置进度值
   *
   * @param progress 进度值
   * @param forceRefresh 是否强制刷新
   */
  setProgress(progress?: number, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(progress)) {
      this.progress = progress;
    }
  }

  /**
   * 设置进度条颜色
   *
   * @param color 进度条颜色
   * @param forceRefresh 是否强制刷新
   */
  setColor(color?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(color)) {
      this.color = color;
    }
  }

  /**
   * 设置进度条背景颜色
   *
   * @param backgroundColor 背景颜色
   * @param forceRefresh 是否强制刷新
   */
  setBackgroundColor(backgroundColor: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(backgroundColor)) {
      this.backgroundColor = backgroundColor;
    }
  }

  /**
   * 设置扩展区指示器小图标显示类型
   *
   * @param indicatorType 显示类型
   * @param forceRefresh 是否强制刷新
   */
  setIndicatorType(indicatorType: number, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(indicatorType)) {
      this.indicatorType = indicatorType;
    }
  }

  /**
   * 设置扩展区指示器小图标
   *
   * @param indicatorIcon 指示器小图标
   * @param forceRefresh 是否强制刷新
   */
  setIndicatorIcon(indicatorIcon?: image.PixelMap, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(indicatorIcon)) {
      if (this.indicatorIcon === indicatorIcon) {
        return;
      }
      this.indicatorIcon?.release();
      this.indicatorIcon = indicatorIcon;
    }
  }

  /**
   * 设置扩展区指示器小图标资源路径
   *
   * @param indicatorIconRes 指示器小图标
   * @param forceRefresh 是否强制刷新
   */
  setIndicatorIconRes(indicatorIconRes?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(indicatorIconRes)) {
      this.indicatorIconRes = indicatorIconRes;
    }
  }

  /**
   * 设置扩展区进度条显示类型
   *
   * @param lineType 进度条显示类型
   * @param forceRefresh 是否强制刷新
   */
  setLineType(lineType?: number, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(lineType)) {
      this.lineType = lineType;
    }
  }

  /**
   *  设置节点图标资源路径列表
   *
   * @param nodeIconsRes 节点图标资源路径
   * @param forceRefresh 是否强制刷新
   */
  setNodeIconsRes(nodeIconsRes: Array<string>, forceRefresh?: boolean): void {
    this.nodeIconsRes = nodeIconsRes || [];
  }

  /**
   *  设置节点图标列表
   *
   * @param nodeIcons 节点图标
   * @param forceRefresh 是否强制刷新
   */
  setNodeIcons(nodeIcons: Array<image.PixelMap>, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(nodeIcons)) {
      let liveButtonArray: LiveButtonArray = new LiveButtonArray();
      liveButtonArray.setButtonArrayByIcons(nodeIcons);
      if (CommonUtils.isInvalid(this.nodeIcons)) {
        this.nodeIcons = liveButtonArray;
      } else {
        this.nodeIcons.update(liveButtonArray);
      }
    }
  }

  /**
   * 释放PixelMap对象
   */
  releaseImages(): void {
    super.releaseImages();
    if (this.indicatorIconRes) {
      log.showInfo('release indicatorIcon');
      this.indicatorIcon?.release();
    }
    if (!ArrayUtils.isEmpty(this.nodeIconsRes)) {
      log.showInfo('release nodeIcons');
      this.nodeIcons?.releaseImages();
    }
  }

  toString(): string {
    return 'LiveProgressTemplate{' +
      ', progress:' + this.progress +
      ', color:' + this.color +
      ', backgroundColor:' + this.backgroundColor +
      ', indicatorType:' + this.indicatorType +
      ', lineType:' + this.lineType +
      '}';
  }
}