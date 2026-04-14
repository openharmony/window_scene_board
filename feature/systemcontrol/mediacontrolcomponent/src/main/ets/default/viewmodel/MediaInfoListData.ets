/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import image from '@ohos.multimedia.image';
import { MediaInfoData } from '../Util/Constants';

@Observed
export class MediaInfoListData {
  public sessionId: string = '';
  public isPlaying: boolean = false;
  public title: string = '';
  public author: string = '';
  public album: string | image.PixelMap = '';
  public appIcon: string | image.PixelMap = '';
  public queueAlbum: string | image.PixelMap = '';
  public queueName: string = '';
  public appName: string = '';
  public hasMedia: boolean = false;
  public isAVQueue: boolean = false;
  public avQueueId: string = '';
  public bundleName: string = '';

  public updateMediaInfoData(mediaInfoData: MediaInfoData) {
    this.sessionId = mediaInfoData.sessionId || '';
    this.isPlaying = mediaInfoData.isPlaying || false;
    this.title = mediaInfoData.title || '';
    this.author = mediaInfoData.author || '';
    this.album = mediaInfoData.album || '';
    this.appIcon = mediaInfoData.appIcon || '';
    this.queueAlbum = mediaInfoData.queueAlbum || '';
    this.queueName = mediaInfoData.queueName || '';
    this.appName = mediaInfoData.appName || '';
    this.hasMedia = mediaInfoData.hasMedia || false;
    this.isAVQueue = mediaInfoData.isAVQueue || false;
    this.avQueueId = mediaInfoData.avQueueId || '';
    this.bundleName = mediaInfoData.bundleName || '';
  }
}