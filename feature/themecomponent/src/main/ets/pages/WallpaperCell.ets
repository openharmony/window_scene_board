import { Log } from '../aigcServiceAbility/IdlService/Log';
import { ImageUtils } from '../utils/ImageUtils';
import { WallpaperCard } from './ShowWallpaperPage';
import { image } from '@kit.ImageKit';

const CELL_WIDTH = 108
const CELL_HEIGHT = 192
const TAG: string = 'ShowWallpaperPage';
@Component
export struct WallpaperCell {
  @State wallpaper: WallpaperCard | null = null
  @State pixelmap: image.PixelMap | null = null
  @State selectedWallpaperId: string = "0";
  selectWallpaperImage?: (wallpaper: WallpaperCard) => void

  aboutToAppear(): void {
    // 由于图片拷贝可能未完成，没有加载到的图片，延迟再重新加载一次
    if (this.wallpaper?.pixelMap) {
      this.pixelmap = this.wallpaper?.pixelMap;
    } else {
      setTimeout(() => {
        this.readLocalImage();
      }, 50);
    }
  }

  private readLocalImage() {
    ImageUtils.readLocalImage(this.wallpaper!.imageUrl).then((data: PixelMap | null) => {
      this.pixelmap = data;
      if (this.wallpaper && data) {
        this.wallpaper.pixelMap = data;
      }
      let isNull = this.pixelmap == null;
      Log.info(TAG, `wallpaper2:${this.wallpaper?.id} ${this.wallpaper!.imageUrl} > ${isNull}`);
    }).catch((error: ESObject) => {
      Log.info(TAG, `wallpaper.imageUrl:${this.wallpaper!.imageUrl} error: ${error}`);
    })
  }

  build() {
    Stack() {
      if (this.pixelmap) {
        // 壁纸图片
        Image(this.pixelmap)
          .width(108)
          .height(192)
          .borderRadius(12)
          .objectFit(ImageFit.Cover)
          .border({
            width: this.wallpaper!.isSelected ? 2 : 0,
            color: '#0A59F7'
          })
          .onClick(() => { //在壁纸页面选择图片进入编辑页面
            this.selectWallpaperImage?.(this.wallpaper!)
          })
          .onError((error) => {

          });
      }

      // 选中状态标记
      if (this.wallpaper!.isSelected) {
        // 右下角选中标记
        Stack() {
          Circle()
            .width(24)
            .height(24)
            .fill('#0A59F7')
            .position({ x: 84, y: 168 });

          Image($r('sys.media.ohos_ic_public_ok'))
            .width(14)
            .height(14)
            .fillColor('#FFFFFF')
            .position({ x: 89, y: 173 });
        }
      }
    }
    .width(CELL_WIDTH)
    .height(CELL_HEIGHT);
  }
}