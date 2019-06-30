#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <SDL/SDL.h>	/*SDL - Simple DirectMedia Layer*/

#include <SDL/SDL_image.h>

void Filter(SDL_Surface *image);
Uint32 getpixel(SDL_Surface *image, int x, int y);
void putpixel(SDL_Surface *image, int x, int y, Uint32 pixel);

SDL_Surface *Load_image(char *file_name)	// dekl. zm. wskaźnikowej
{
    SDL_Surface *tmp = IMG_Load(file_name); /* Open the image file*/ 
    if (tmp == NULL) 
    {
        //fprintf(stderr, "Couldn't load %s: %s\n", file_name, SDL_GetEror());
        fprintf(stderr, "Couldn't load %s:\n", file_name);
        exit(0);
    }

    return tmp;
}

/* wyświetlenie obrazka na terminalu BLIT (Bell Labs Intelligent Terminal */ 
void Paint(SDL_Surface *image, SDL_Surface* screen) 
{
    /*BLIT (Bell Labs Intelligent Terminal) – programowalny terminal graficzny bmp*/ 
    SDL_BlitSurface(image, NULL, screen, NULL);
    
    if(SDL_BlitSurface(image, NULL, screen, NULL) < 0)
    {
        //fprintf(stderr, "BlitSurface eror: %s\n", SDL_GetEror());
        fprintf(stderr, "BlitSurface eror: \n");
    }

    SDL_UpdateRect(screen, 0, 0, 0, 0);
};

int main(int argc, char *argv[])
{
    Uint32 flags;
    SDL_Surface *screen, *image;
    int depth, done;
    SDL_Event event;

    if ( ! argv[1] ) 
    { 
        // Check command line usage.
        fprintf(stderr, "Usage: %s <image_file>, (int) size\n", argv[0]);
        return(1);
    }

    if (! argv[2]) 
    {
        fprintf(stderr, "Usage: %s <image_file>, (int) size\n", argv[0]);
        return(1);
    }

    if ( SDL_Init(SDL_INIT_VIDEO) < 0 ) 
    {
        //fprintf(stderr, "Couldn't initialize SDL: %s\n",SDL_GetEror());
        fprintf(stderr, "Couldn't initialize SDL: \n");
        return(255);
    }

    flags = SDL_SWSURFACE;
    image = Load_image( argv[1] );

    printf( "\n\nImage properts:\n" );
    printf( "BitsPerPixel = %i \n", image->format->BitsPerPixel ); 
    printf( "BytesPerPixel = %i \n", image->format->BytesPerPixel ); 
    printf( "width %d ,height %d \n\n", image->w, image->h ); 
    SDL_WM_SetCaption(argv[1], "showimage");

    /* Create a display for the image, except that we emulate 32bpp*/ 

    depth = SDL_VideoModeOK(image->w, image->h, 32, flags);

    if (depth==0)
    {

        if (image->format->BytesPerPixel>1) 
        {
        depth=32;
        }
        else
        {
            depth=8;
        }  

    }
    else
    {
        if ((image->format->BytesPerPixel>1) && (depth==8) )
        {
            depth = 32;
        }

        if(depth == 8) //Use the deepest native mode for non-indexed imagenon-indexed images on 8bpp scr 
        {
            flags |= SDL_HWPALETTE;
        }

        screen = SDL_SetVideoMode(image->w, image->h, depth, flags);

        if ( screen == NULL ) 
        {
            //fprintf(stderr,"Couldn't set %dx%dx%d video mode: %s\n", image->w, image->h, depth, SDL_GetEror());
            fprintf(stderr,"Couldn't set %dx%dx%d video mode: \n", image->w, image->h, depth);
            exit(1);	// Set
        }

        printf("Set 640x480 at %d bits-per-pixel mode\n",screen->format->BitsPerPixel);

        /* Set the palette, if one exists */

        if (image->format->palette && screen->format->palette)
        {
            SDL_SetColors(screen, image->format->palette->colors, 0, image->format->palette->ncolors);
        }

        Paint(image, screen);	// Display the image

        done = 0;

        int size =atoi( argv[2] );

        printf("Actual size is: %d\n", size);

        while (! done)
        {
            if ( SDL_PollEvent(&event) ) 
            {
                switch (event.type) 
                {
                    case SDL_KEYUP:
                        switch (event.key.keysym.sym) 
                        {
                            case SDLK_ESCAPE:
                            case SDLK_TAB:
                            case SDLK_q:
                                done = 1;
                                break;

                            case SDLK_SPACE:
                            case SDLK_f:
                                SDL_LockSurface(image);
                                printf("Start filtering...	");
                                
                                Filter(image);
                                    // Uint8 bpp = surface->format->BytesPerPixel;

                                    // printf("DAWID: %d", bpp);
                                //printf("Dawid nie Done.\n");
                                
                                SDL_UnlockSurface(image);
                                printf("Repainting after filtered...	");
                                
                                //Paint(image, screen);
                                printf("Done.\n");
                                break;

                            case SDLK_r:
                                printf("Reloading image...	");
                                image = Load_image( argv[1] );
                                Paint(image,screen);
                                printf("Done.\n");
                                break;

                            case SDLK_PAGEDOWN:
                            case SDLK_DOWN:
                            case SDLK_KP_MINUS:
                                size--;
                                if (size==0) size--;
                                printf("Actual size is: %d\n", size);
                                break;

                            case SDLK_PAGEUP:
                            case SDLK_UP:
                            case SDLK_KP_PLUS:
                                size++;
                                if (size==0)
                                {
                                    size++;
                                }

                                printf("Actual size is: %d\n", size);
                                break;

                            case SDLK_s:
                                printf("Saving surface at nowy.bmp ...");
                                SDL_SaveBMP(image, "nowy.bmp" );
                                printf("Done.\n");

                            default:
                                break;

                        }
                        break;

                    case SDL_MOUSEBUTTONDOWN:
                        done = 1;
                        break;

                    case SDL_QUIT:
                        done = 1;
                        break;

                    default:
                        break;
                }
            }
            else
            {
                SDL_Delay(10);
            }
        }

        SDL_FreeSurface(image);
        /* We're done! */
        SDL_Quit();
        return(0);
    }
}

// void Filter(SDL_Surface *screen, int width,int height,int size,char bpp)
void Filter(SDL_Surface *screen)
{
    int width = screen->w;
    int height = screen->h;
    char bytesPerPixel = screen->format->BytesPerPixel;


    SDL_Surface *new_screen; //nowa tymczasowa powierzchnia

    new_screen = SDL_CreateRGBSurface(0,height,width,32,0,0,0,0); // nowe wymiary

    Uint32 old_pixel;	// obecnie przetwarzany piksel

    int x, y;

    for (x = 0; x < width; x++) 
    {
        for (y = 0; y < height; y++)
        {
            // old_pixel = getpixel(screen, width - x, height - y);	//pobranie
            old_pixel = 0x00ffff00;	//pobranie



            putpixel(new_screen, y, x, old_pixel);	//wstawienie w innym miejscu
        }

    }

    screen = SDL_SetVideoMode(height, width, 32, SDL_SWSURFACE);

    SDL_BlitSurface(new_screen,NULL,screen,NULL);	// stara powierzchnia nową
    SDL_FreeSurface(new_screen);	// zwolnienie pamięci

    SDL_UpdateRect(screen, 0, 0, 0, 0);	// odświeżenie obrazu
}



// // void Filter(unsigned char *buf, int width,int height,int size, char bpp);
// // void Filter(SDL_Surface *screen, int width, int height, int size, char bpp)
// void Filter(SDL_Surface *image)
// {
//     int width = image->w;
//     int height = image->h;
//     char bytesPerPixel = image->format->BytesPerPixel;

//     SDL_Surface *new_screen; //nowa tymczasowa powierzchnia
//     new_screen = SDL_CreateRGBSurface(0,height,width,32,0,0,0,0); // nowe wymiary

//     Uint32 old_pixel;	// obecnie przetwarzany piksel

//     int x, y;
//     for (x = 0; x < width; x++)
//     {
//         for (y = 0; y < height; y++)
//         {
//             // old_pixel = getpixel(image, width - x, height - y);	// pobranie
//             // old_pixel &= 0x00000000;
//             old_pixel = 0;
//             putpixel(new_screen, x, y, old_pixel);	//wstawienie w innym miejscu
//         }
//     }

//     image = SDL_SetVideoMode(width, height, 32, SDL_SWSURFACE);

//     SDL_BlitSurface(new_screen,NULL,image,NULL);	// stara powierzchnia nową

//     SDL_FreeSurface(new_screen);	// zwolnienie pamięci

//     SDL_UpdateRect(image, 0, 0, 0, 0);	// odświeżenie obrazu
//     //SDL_UpdateRect(new_screen, 0, 0, 0, 0);	// odświeżenie obrazu
// }

// Pobranie piksela obrazu − getpixel()

//Return the (x,y) pixel value. The surface must be locked before calling this!
    
Uint32 getpixel(SDL_Surface *surface,  int x, int y)
{
    Uint8 bpp = surface->format->BytesPerPixel;

    // printf("Dawid: %d", bpp);

    /* Here p is the address to the pixel we want to retrieve */
    // Uint8 *p = (Uint8 *)surface->pixels + y * surface->pitch + x * bytesPerPixel;
    Uint8 *p = (Uint8 *)surface->pixels + y * surface->pitch + x * bpp;
    switch(bpp) 
    {
        case 1:
            return *p;
        case 2:
            return *(Uint16 *)p;
        case 3:
            if(SDL_BYTEORDER == SDL_BIG_ENDIAN)
            {
                return p[0] << 16 | p[1] << 8 | p[2];
            }
            else
            {
                return p[0] | p[1] << 8 | p[2] << 16; 
            }
        case 4:
            return *(Uint32 *)p;
        default:
            return 0;	/* shouldn't happen, but avoids warnings */
    }

    //return p;

}

// Wstawianie pixela − putpixel()

void putpixel(SDL_Surface *surface, int x, int y, Uint32 pixel)
{
    int bpp = surface->format->BytesPerPixel;

    Uint8 *p = (Uint8 *)surface->pixels + y * surface->pitch + x * bpp;
    
    switch(bpp) 
    {
        case 1:
            *p = pixel;	// p - addres pixela
            break;
        case 2:
            *(Uint16 *)p = pixel;
            break;
        case 3:
            if(SDL_BYTEORDER == SDL_BIG_ENDIAN) 
            {
                p[0] = (pixel >> 16) & 0xff;
                p[1] = (pixel >> 8) & 0xff;
                p[2] = pixel & 0xff;
            }
            else
            {
                p[0] = pixel & 0xff;
                p[1] = (pixel >> 8) & 0xff;
                p[2] = (pixel >> 16) & 0xff;
            }
            break;
        case 4:
            *(Uint32 *)p = pixel;
            break;

    }
}

//     /* ustawienie żółtej plamki ((R=0xff, G=0xff, B=0x00)) na środku ekranu */ 
//     int x, y;
//     Uint32 yellow;

//     /* Note: If the display is palettized, you must set the palette first. */ 
//     yellow = SDL_MapRGB(screen->format, 0xff, 0xff, 0x00);
//     x = screen->w / 2;
//     y = screen->h / 2;

//     /* Lock the screen for direct access to the pixels */ 
//     if ( SDL_MUSTLOCK(screen) )
//     {
//         if ( SDL_LockSurface(screen) < 0 )
//         {
//             fprintf(stderr, "Can't lock screen: %s\n", SDL_GetEror()); return;
//         }
//     }

//     putpixel(screen, x, y, yellow);

//     if ( SDL_MUSTLOCK(screen) ) 
//     {
//         SDL_UnlockSurface(screen);
//     }
// }