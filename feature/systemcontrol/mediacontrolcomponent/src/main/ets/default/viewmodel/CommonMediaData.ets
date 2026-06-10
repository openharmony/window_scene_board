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
import { BasicMediaData } from './BasicMediaVM';

/*
  基础播控显示数据
 */
@Observed
export class CommonMediaData extends BasicMediaData {

  /**
   * 歌曲id
   */
  public assetId: string = '';

  /**
   * 歌曲标题
   */
  @Track public title: string = '';

  /**
   * 歌曲副标题（作者）
   */
  @Track public artist: string = '';

  /**
   * 播放状态
   */
  @Track public playState: number = 0;

  /*
    支持指令状态
   */
  @Track public isCanPlay: boolean = false;
  @Track public isCanPause: boolean = false;
  @Track public isCanPlayNext: boolean = false;
  @Track public isCanPlayPrev: boolean = false;
  @Track public isCanFastForward: boolean = false;
  @Track public isCanRewind: boolean = false;

  /**
   * assetId改变时需要清理的数据
   */
  public clearForAssetIdChange() {
    this.title = '';
    this.artist = '';
    this.playState = 0;
  }
}

export { BasicMediaData };
